# == Schema Information
#
# Table name: spaces
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  user_id       :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe SpacesController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)

    fSpace = Feature.create!(name: 'Amount of spaces')
    fTeam = Feature.create!(name: 'Team members')

    # Number of spaces for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fSpace.id, value: '3')

    # Team members for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fTeam.id, value: '2')

    user = User.new(username: 'user_name',
                    passwd: '12345678')
    email = Email.new(email: 'user@watchiot.com')
    User.register user, email

    user_new = User.find_by_username 'user_name'
    email_login = user_new.emails.first
    user_new.active_account(email_login)

    @user = User.login 'user@watchiot.com', '12345678'
    request.cookies[:auth_token] = @user.auth_token

    user = User.new(username: 'user_name_unauthorized',
                    passwd: '12345678')
    email = Email.new(email: 'user_unauthorized@watchiot.com')
    User.register user, email

    @user_new = User.find_by_username 'user_name_unauthorized'
    email_login = @user_new.emails.first
    @user_new.active_account(email_login)

    params = { name: 'my_space',
               description: 'space description'}
    Space.create_new_space params, @user, @user

  end

  describe 'all spaces' do
    it 'using get all space has a 200 status code' do
      get :index, params: { username: 'user_name' }
      expect(assigns[:spaces].length).to eq(1)
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
    end

    it 'using get all space with bad user has a 404 status code' do
      get :index, params: { username: 'user_name_not_exist' }
      expect(assigns[:spaces]).to be_nil
      expect(response.status).to eq(404)
    end

    it 'using get all space with user not authorized has a 401 status code' do
      get :index, params: { username: 'user_name_unauthorized' }
      expect(assigns[:spaces]).to be_nil
      expect(response.status).to eq(401)
    end

    it 'using get all space with user authorized but bad way has a 401 status code' do
      Team.add_member @user, 'user_unauthorized@watchiot.com'

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)

      # i am trying to access to 'user_name_unauthorized' spaces with i do not permission
      # 'user_name_unauthorized' has permission to access are my spaces not the other way
      get :index, params: { username: 'user_name_unauthorized' }
      expect(assigns[:spaces]).to be_nil
      expect(response.status).to eq(401)
    end

    it 'using get all space with user authorized has a 200 status code' do
      Team.add_member @user_new, 'user@watchiot.com'

      user = User.find_by_username @user_new.username
      expect(user.teams.length).to eq(1)

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(0)

      # access to 'user_name_unauthorized' spaces
      get :index, params: { username: 'user_name_unauthorized' }
      expect(assigns[:spaces].length).to eq(0)
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
    end
  end

  describe 'show space' do
    it 'using get has a 200 status code' do
      get :show, params: { username: 'user_name', namespace: 'my_space' }
      expect(assigns[:project]).to_not be_nil
      expect(response.status).to eq(200)
      expect(response).to render_template('show')
    end

    it 'using get show not exist space has a 404 status code' do
      get :show, params: { username: 'user_name', namespace: 'my_space_not_exist' }
      expect(response.status).to eq(404)
    end

    it 'using get show not permission space has a 401 status code' do
      get :show, params: { username: 'user_name_unauthorized', namespace: 'my_space_unauthorized' }
      expect(response.status).to eq(401)
    end
  end

  describe 'POST create space' do
    it 'using post has a 302 status code' do
      post :create, params: { username: 'user_name', space: {name: 'my_new space',
                                                   description: 'my description' }}
      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(2)
      expect(spaces.last.name).to eq('my_new-space')
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_new-space')
    end

    it 'using post create the same space name has a 302 status code' do
      post :create, params: { username: 'user_name', space: { name: 'my_new space',
                                                   description: 'my description' }}
      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(2)
      expect(spaces.last.name).to eq('my_new-space')
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_new-space')

      post :create, params: { username: 'user_name', space: { name: 'my_new-space',
                                                   description: 'my description' }}

      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(2)
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/spaces')
      expect(flash[:error]).to eq('Name You have a space with this name')
    end

    it 'using post create an empty name has a 302 status code' do
      post :create, params: { username: 'user_name', space: { name: '',
                                                   description: 'my description' }}
      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(1)
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/spaces')
      expect(flash[:error]).to eq('Name can\'t be blank')
    end

    it 'using post create a nil name has a 302 status code' do
      post :create, params: { username: 'user_name', space: { name: nil,
                                                   description: 'my description' }}
      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(1)
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/spaces')
      expect(flash[:error]).to eq('Name can\'t be blank')
    end
  end

  describe 'edit space' do
    it 'using patch has a 302 status code' do
      patch :edit, params: { username: 'user_name', namespace: 'my_space',
            space: { description: 'my new description' }}
      space = Space.find_by_user_id @user.id
      expect(space.description).to eq('my new description')
      expect(assigns[:project]).to_not be_nil
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_space')
    end

    it 'using patch it can not change the namespace has a 302 status code' do
      patch :edit, params: { username: 'user_name', namespace: 'my_space',
            space: { name: 'new_my space', description: 'my new description' }}

      space = Space.find_by_user_id @user.id
      expect(space.description).to eq('my new description')
      expect(space.name).to_not eq('new_my-space')
      expect(space.name).to eq('my_space')
      expect(assigns[:project]).to_not be_nil
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_space')
    end
  end

  describe 'setting space' do
    it 'using get to access setting has a 200 status code' do
      get :setting, params: { username: 'user_name', namespace: 'my_space' }
      expect(assigns[:teams]).to_not be_nil
      expect(response.status).to eq(200)
      expect(response).to render_template('setting')
    end

    it 'using get to access setting has a 200 status code' do
      get :setting, params: { username: 'user_name', namespace: 'my_space_not_exist' }
      expect(assigns[:teams]).to be_nil
      expect(response.status).to eq(404)
    end
  end

  describe 'change name space setting' do
    it 'using patch has a 302 status code' do
      patch :change, params: { username: 'user_name', namespace: 'my_space',
            space: { name: 'my_new space', description: 'my new description' }}
      space = Space.find_by_user_id @user.id
      expect(space.name).to eq('my_new-space')
      expect(space.description).to_not eq('my new description')
      expect(space.description).to eq('space description')
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_new-space/setting')
    end

    it 'using patch empty new namespace has a 302 status code' do
      patch :change, params: { username: 'user_name', namespace: 'my_space',
            space: { name: '', description: 'my new description' }}
      space = Space.find_by_user_id @user.id
      expect(space.name).to_not eq('my_new-space')
      expect(space.description).to_not eq('my new description')
      expect(space.description).to eq('space description')
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_space/setting')
      expect(flash[:error]).to eq('Name can\'t be blank')
    end

    it 'using patch nil new namespace has a 302 status code' do
      patch :change, params: { username: 'user_name', namespace: 'my_space',
            space: { name: nil, description: 'my new description' }}
      space = Space.find_by_user_id @user.id
      expect(space.name).to_not eq('my_new-space')
      expect(space.description).to_not eq('my new description')
      expect(space.description).to eq('space description')
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_space/setting')
      expect(flash[:error]).to eq('Name can\'t be blank')
    end
  end

  describe 'transfer space setting no member' do
    it 'using patch member is not valid has a 302 status code' do
      patch :transfer, params: { username: 'user_name', namespace: 'my_space',
            user_member_id: '1' }

      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(1)

      spaces = Space.where(user_id: @user_new.id).all
      expect(spaces.length).to eq(0)

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_space/setting')
      expect(flash[:error]).to eq('The member is not valid')
    end

    it 'using patch member valid has a 302 status code' do
      Team.add_member(@user, "user_unauthorized@watchiot.com")

      patch :transfer, params: { username: 'user_name', namespace: 'my_space',
            user_team_id: @user_new.id }

      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(0)

      spaces = Space.where(user_id: @user_new.id).all
      expect(spaces.length).to eq(1)

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/spaces')
    end

    it 'using patch member valid but he has a space with that name has a 302 status code' do
      Team.add_member(@user, 'user_unauthorized@watchiot.com')

      params = { name: 'my_space',
                 description: 'space description'}
      Space.create_new_space params, @user_new, @user_new

      patch :transfer, params: { username: 'user_name', namespace: 'my_space',
            user_team_id: @user_new.id }

      spaces = Space.where(user_id: @user.id).all
      expect(spaces.length).to eq(1)

      spaces = Space.where(user_id: @user_new.id).all
      expect(spaces.length).to_not eq(3)

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_space/setting')
      expect(flash[:error]).to eq('The team member has a space with this name')
    end
  end

  describe 'delete space setting' do
    it 'using delete has a 302 status code' do
      delete :delete, params: { username: 'user_name', namespace: 'my_space',
             space: { :name => 'my_space' }}

      space = Space.find_by_user_id(@user.id)
      expect(space).to be_nil
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/spaces')
    end

    it 'using delete with bad confirmation has a 302 status code' do
      delete :delete, params: { username: 'user_name', namespace: 'my_space',
             space: { :name => 'bad_my_space_confirmation' }}

      space = Space.find_by_user_id(@user.id)
      expect(space).to_not be_nil
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/my_space/setting')
      expect(flash[:error]).to eq('The namespace is not valid')
    end
  end
end

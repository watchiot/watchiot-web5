# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(25)
#  first_name             :string(25)
#  last_name              :string(35)
#  address                :text
#  country_code           :string(3)
#  phone                  :string(15)
#  status                 :boolean          default(TRUE)
#  receive_notif_last_new :boolean          default(TRUE)
#  passwd                 :string
#  passwd_salt            :string
#  auth_token             :string
#  provider               :string
#  uid                    :string
#  plan_id                :integer
#  api_key_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)

    fSpace = Feature.create!(name: 'Number of spaces')
    fTeam = Feature.create!(name: 'Team members')

    # Number of spaces for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fSpace.id, value: '3')

    # Team members for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fTeam.id, value: '3')

    @user = User.new(username: 'user_name',
                    passwd: '12345678')
    email = Email.new(email: 'user@watchiot.com')
    User.register @user, email

    email_login = @user.emails.first
    @user.active_account(email_login)

    @user_two = User.new(username: 'user_name2',
                    passwd: '12345678')
    email = Email.new(email: 'user2@watchiot.com')
    User.register @user_two, email
  end

  describe 'register' do
    it 'using post has a 200 status code' do
      post :do_register, params: { email: 'myemail@watchiot.com',
          user: { username: 'my_user', passwd: '12345678'}}

      expect(response.status).to eq(200)
      expect(response).to render_template('need_verify_notification')
    end

    it 'using post register password too short has a 200 status code' do
      post :do_register, params: { email: 'myemail@watchiot.com',
           user: { username: 'my_user', passwd: '123'}}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Password has less than 8 characters.')
    end

    it 'using post register username empty has a 200 status code' do
      post :do_register, params: { email: 'myemail@watchiot.com',
           user: { username: '', passwd: '123123123'}}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Username is too short (minimum is 1 character), Username can\'t be blank')
    end

    it 'using post register username nil has a 200 status code' do
      post :do_register, params: { email: 'myemail@watchiot.com',
           user: { username: nil, passwd: '123123123' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Username is too short (minimum is 1 character), Username can\'t be blank')
    end

    it 'using post register username exist has a 200 status code' do
      post :do_register, params: { email: 'myemail@watchiot.com',
           user: { username: 'user_name', passwd: '123123123' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Username has already been taken')
    end
  end

  describe 'login' do
    it 'using post has a 302 status code' do
      get :do_login, params: { user: { username: 'user_name',
                           passwd: '12345678' }}
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name')
    end

    it 'using post with email has a 302 status code' do
      get :do_login, params: { user: { username: 'user@watchiot.com',
                            passwd: '12345678' }}
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name')
    end

    it 'using post bad password has a 200 status code' do
      get :do_login, params: { user: { username: 'user@watchiot.com',
                            passwd: '1234567891' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post bad username has a 200 status code' do
      get :do_login, params: { user: { username: 'my_user_name_new',
                            passwd: '12345678' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post bad email has a 200 status code' do
      get :do_login, params: { user: { username: 'my_user_name_new@watchiot.com',
                             passwd: '12345678' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post inactive user has a 200 status code' do
      get :do_login, params: { user: { username: 'user_name2',
                             passwd: '12345678' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post inactive email has a 200 status code' do
      get :do_login, params: { user: { username: 'user2@watchiot.com',
                             passwd: '12345678' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post empty username has a 200 status code' do
      get :do_login, params: { user: { username: '',
                             passwd: '12345678' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post nil username has a 200 status code' do
      get :do_login, params: { user: { username: nil,
                             passwd: '12345678' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post empty password has a 200 status code' do
      get :do_login, params: { user: { username: 'user@watchiot.com',
                            passwd: '' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post nil password has a 200 status code' do
      get :do_login, params: { user: { username: 'user@watchiot.com',
                            passwd: nil }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post empty username and password has a 200 status code' do
      get :do_login, params: { user: { username: '', passwd: '' }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end

    it 'using post nil username and password has a 200 status code' do
      get :do_login, params: { user: { username: nil, passwd: nil }}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
      expect(flash[:error])
          .to eq('Account is not valid')
    end
  end

  describe 'GET logout' do
    it 'has a 302 status code' do
      get :logout
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/')
    end
  end
end

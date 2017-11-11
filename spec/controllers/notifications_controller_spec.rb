require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)
    fTeam = Feature.create!(name: 'Team members')

    PlanFeature.create(plan_id: plan.id,
                       feature_id: fTeam.id, value: '2')

    # add one users
    @user = User.new(username: 'my_user_name',
               passwd: '12345678')
    email = Email.new(email: 'newemail@watchiot.com')

    User.register @user, email

    @email = Email.create!(email: 'user@watchiot.com',
                           user_id: @user.id)

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'reset', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'register', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'verify_email', data: 'user@watchiot.com')

    new_user = User.new(username: 'my_new_user_name', passwd: '12345678')
    email = Email.new(email: 'user_new@watchiot.com')
    User.register new_user, email

    Team.add_member @user, 'user_new@watchiot.com'

    VerifyClient.create!(user_id: new_user.id, token: '12345',
                         concept: 'invited', data: 'user_new@watchiot.com')
  end

  describe 'forgot notification' do
    it 'has a 200 status code, all is ok' do
      get :forgot
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot')
    end

    it 'using post has a 200 status code' do
      post :forgot_notification, params: { user: {username: 'my_user_name'} }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot_notification')
    end

    it 'using post with user not exist has a 200 status code too for security reasons' do
      post :forgot_notification, params: { user: {username: 'my_user_name_bad'} }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot_notification')
    end
  end

  describe 'reset' do
    it 'has a 200 status code, good token' do
      get :reset, params: { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/reset')
    end

    it 'using bad token for rest has a 404 status code' do
      get :reset, params: { token: '12345678' }
      expect(response.status).to eq(404)
    end

    it 'using patch has a 302 status code, great' do
      patch :do_reset, params: { token: '12345',
            user: { passwd_new: 'my_user_name' } }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/#get-started')
    end

    it 'using patch with password to short has a 200 status code' do
      patch :do_reset, params: { token: '12345',
            user: { passwd_new: '123'} }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/reset')
      expect(flash[:error]).to eq('Password has less than 8 characters')
    end
  end

  describe 'active' do
    it 'has a 302 status code, activate ok' do
      get :active, params: { token: '12345' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/' + @user.username)
    end

    it 'using bad token for activate has a 404 status code' do
      get :active, params: { token: '12345678' }
      expect(response.status).to eq(404)
    end
  end

  describe 'GET verify email' do
    it 'using correct token has a 200 status code' do
      get :verify_email, params: { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/verify_email')
    end

    it 'using bad token for verify has a 404 status code' do
      get :active, params: { token: '12345678' }
      expect(response.status).to eq(404)
    end
  end

  describe 'invite' do
    it 'using get for invite has a 200 status code' do
      get :invite, params: { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/invited')
    end

    it 'using bad token for invite has a 404 status code' do
      get :active, params: { token: '12345678' }
      expect(response.status).to eq(404)
    end

    it 'using patch to active the account invited has a 302 status code' do
      patch :do_invite, params: { token: '12345',
          user: { username: 'my_new_user_name',
                  passwd: 'my_new_user_name'}}
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/my_new_user_name')
    end

    it 'using patch to active the account with password to short has a 200 status code' do
      patch :do_invite, params: { token: '12345',
            user: { passwd: '123' }}
      expect(response.status).to eq(200)
      expect(response).to render_template('users/invited')
      expect(flash[:error]).to eq('Password has less than 8 characters.')
    end
  end
end

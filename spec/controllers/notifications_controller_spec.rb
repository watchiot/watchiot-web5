require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add one users
    @user = User.new(username: 'my_user_name',
               passwd: '12345678',
               passwd_confirmation: '12345678')
    email = Email.new(email: 'newemail@watchiot.com')
    @user.register email

    @email = Email.create!(email: 'user@watchiot.com',
                           user_id: @user.id)

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'reset', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'register', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'verify_email', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'invited', data: 'user@watchiot.com')
  end

  describe 'forgot notification' do
    it 'has a 200 status code, all is ok' do
      get :forgot
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot')
    end

    it 'using post has a 200 status code' do
      post :forgot_notification, user: {username: 'my_user_name'}
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot_notification')
    end

    it 'using post with user not exist has a 200 status code too for security reasons' do
      post :forgot_notification, user: {username: 'my_user_name_bad'}
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot_notification')
    end
  end

  describe 'reset' do
    it 'has a 200 status code, good token' do
      get :reset, { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/reset')
    end

    it 'using bad token for rest has a 404 status code' do
      get :reset, { token: '12345678' }
      expect(response.status).to eq(404)
    end

    it 'using patch has a 302 status code, great' do
      patch :do_reset, token: '12345',
            user: {passwd_new: 'my_user_name',
                   passwd_confirmation: 'my_user_name'}
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/login')
    end

    it 'using patch with not match password has a 200 status code' do
      patch :do_reset, token: '12345',
            user: {passwd_new: 'my_user_name',
                   passwd_confirmation: 'my_user_name_bad'}
      expect(response.status).to eq(200)
      expect(response).to render_template('users/reset')
      expect(flash[:error]).to eq('Password does not match the confirm')
    end

    it 'using patch with password to short has a 200 status code' do
      patch :do_reset, token: '12345',
            user: {passwd_new: '123',
                   passwd_confirmation: '123'}
      expect(response.status).to eq(200)
      expect(response).to render_template('users/reset')
      expect(flash[:error]).to eq('Password has less than 8 characters')
    end
  end

  describe 'active' do
    it 'has a 302 status code, activate ok' do
      get :active, { token: '12345' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/' + @user.username)
    end

    it 'using bad token for activate has a 404 status code' do
      get :active, { token: '12345678' }
      expect(response.status).to eq(404)
    end
  end

  describe 'GET verify email' do
    it 'using correct token has a 200 status code' do
      get :verify_email, { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/verify_email')
    end

    it 'using bad token for verify has a 404 status code' do
      get :active, { token: '12345678' }
      expect(response.status).to eq(404)
    end
  end

  describe 'invite' do
    it 'using get for invite has a 200 status code' do
      get :invite, { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/invited')
    end

    it 'using bad token for invite has a 404 status code' do
      get :active, { token: '12345678' }
      expect(response.status).to eq(404)
    end

    it 'using patch to active the account invited has a 302 status code' do
      patch :do_invite, token: '12345',
          user: { username: 'my_user_name',
                  passwd: 'my_user_name',
                  passwd_confirmation: 'my_user_name'}
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/' + @user.username)
    end

    it 'using patch to active the account with not match password has a 200 status code' do
      patch :do_invite, token: '12345',
            user: {passwd: 'my_user_name',
                   passwd_confirmation: 'my_user_name_bad'}
      expect(response.status).to eq(200)
      expect(response).to render_template('users/invited')
      expect(flash[:error]).to eq('Password does not match the confirm')
    end

    it 'using patch to active the account with password to short has a 200 status code' do
      patch :do_invite, token: '12345',
            user: {passwd: '123',
                   passwd_confirmation: '123'}
      expect(response.status).to eq(200)
      expect(response).to render_template('users/invited')
      expect(flash[:error]).to eq('Password has less than 8 characters')
    end
  end
end

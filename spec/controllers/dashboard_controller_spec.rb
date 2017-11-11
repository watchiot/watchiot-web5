require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add one users
    @user = User.new(username: 'user_name',
                    passwd: '12345678')
    email = Email.new(email: 'user@watchiot.com')
    User.register @user, email

    user_new = User.find_by_username 'user_name'
    email_login = user_new.emails.first
    user_new.active_account(email_login)

    @user = User.login 'user@watchiot.com', '12345678'
    request.cookies[:auth_token] = @user.auth_token

    Log.create!(description: 'my log', action: 'add a new space', user_id: @user.id, user_action_id: @user.id)
  end

  describe 'dashboard show' do
    it 'get dashboard show has a 200 status code, all is ok' do
      get :show, params: { username: @user.username }

      expect(response.status).to eq(200)
      expect(response).to render_template('show')
      expect(assigns[:space]).to_not be_nil
      expect(assigns[:logs]).to_not be_nil
    end

    it 'get dashboard show unauthorised user has a 404 status code, all is ok' do
      get :show, params: { username: 'any_user' }
      expect(response.status).to eq(404)
      expect(assigns[:space]).to be_nil
      expect(assigns[:logs]).to be_nil
    end
  end


end

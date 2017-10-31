require 'rails_helper'

RSpec.describe SettingController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)

    fTeam = Feature.create!(name: 'Team members')

    # Team members for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fTeam.id, value: '3')

    user = User.new(username: 'user_name',
                    passwd: '12345678',
                    passwd_confirmation: '12345678')
    email = Email.new(email: 'user@watchiot.com')
    user.register email

    user_new = User.find_by_username 'user_name'
    email_login = user_new.emails.first
    user_new.active_account(email_login)

    @user = User.login 'user@watchiot.com', '12345678'
    request.cookies[:auth_token] = @user.auth_token

    user = User.new(username: 'user_name_unauthorized',
                    passwd: '12345678',
                    passwd_confirmation: '12345678')
    email = Email.new(email: 'user_unauthorized@watchiot.com')
    user.register email

  end

  describe 'using get user setting with permissions' do
    it 'has a 200 status code' do
      get :show, username: 'user_name'
      expect(response.status).to eq(200)
    end

    it ' user setting unauthorized has a 401 status code' do
      get :show, username: 'user_name_unauthorized'
      expect(response.status).to eq(401)
    end

    it 'using get not found user setting has a 404 status code' do
      get :show, username: 'user_name_not_exist'
      expect(response.status).to eq(404)
    end
  end

  describe 'Patch profile setting' do
    it 'has a 302 status code' do
      user = User.find_by_username 'user_name'
      expect(user.first_name).to be_nil
      expect(user.last_name).to be_nil
      expect(user.phone).to be_nil
      expect(user.country_code).to be_nil
      expect(user.address).to be_nil

      patch :profile, username: 'user_name',
            user: {first_name: 'User',
                   last_name: 'Name',
                   phone: '172823424',
                   country_code:'EUA',
                   address: 'Miami'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting')

      user = User.find_by_username 'user_name'
      expect(user.first_name).to eq('User')
      expect(user.last_name).to eq('Name')
      expect(user.phone).to eq('172823424')
      expect(user.country_code).to eq('EUA')
      expect(user.address).to eq('Miami')
    end
  end

  describe 'workin with email setting' do
    it 'using post to add a new email has a 302 status code' do
      post :account_add_email, username: 'user_name',
            email: {email: 'my_new_email@watchiot.com'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(2)
    end

    it 'using post to add a bad email has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: 'my_new_email^&%watchiot.com'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('Email The email is not valid')

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(1)
    end

    it 'using post to add a nil email has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: nil}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('Email The email is not valid, Email can\'t be blank')

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(1)
    end

    it 'using post to add a nil email has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: ''}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('Email The email is not valid, Email can\'t be blank')

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(1)
    end

    it 'Delete an email setting has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: 'my_new_email@watchiot.com'}

      email = Email.find_by_email 'my_new_email@watchiot.com'

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(2)

      delete :account_remove_email, username: 'user_name', id: email.id
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(1)
    end

    it 'Delete an not exists email setting has a 302 status code' do
      delete :account_remove_email, username: 'user_name', id: -1
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('The email is not valid')
    end

    it 'Delete an email with not belong you setting has a 302 status code' do
      email = Email.find_by_email 'user_unauthorized@watchiot.com'
      delete :account_remove_email, username: 'user_name', id: email.id
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('The email is not valid')
    end

    it 'add email like primary setting has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: 'my_new_email@watchiot.com'}

      email = Email.find_by_email 'my_new_email@watchiot.com'
      email.verify_email
      expect(email.checked).to be(true)

      get :account_primary_email, username: 'user_name',
           id: email.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(2)

      email = Email.find_by_email 'user@watchiot.com'
      expect(email.primary).to be(false)

      email = Email.find_by_email 'my_new_email@watchiot.com'
      expect(email.primary).to be(true)
    end

    it 'send email verify setting has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: 'my_new_email@watchiot.com'}

      email = Email.find_by_email 'my_new_email@watchiot.com'

      post :account_verify_email, username: 'user_name',
           id: email.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
    end
  end

  describe 'Change password setting' do
    it 'using patch change password fine has a 302 status code' do
      patch :account_ch_password, username: 'user_name',
           user: {passwd: '12345678', passwd_new: '87654321',
                     passwd_confirmation: '87654321'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')

      expect { User.login 'user@watchiot.com', '12345678' }
          .to raise_error('Account is not valid')

      expect { User.login 'user@watchiot.com', '87654321' }
          .to_not raise_error
    end

    it 'using patch change password too short has a 302 status code' do
      patch :account_ch_password, username: 'user_name',
            user: {passwd: '12345678', passwd_new: '8765',
                   passwd_confirmation: '8765'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('Password has less than 8 characters')

      expect { User.login 'user@watchiot.com', '8765' }
          .to raise_error('Account is not valid')

      expect { User.login 'user@watchiot.com', '12345678' }
          .to_not raise_error
    end

    it 'using patch change password not match has a 302 status code' do
      patch :account_ch_password, username: 'user_name',
            user: {passwd: '12345678', passwd_new: '123456123123',
                   passwd_confirmation: '12345123322'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('Password does not match the confirm')

      expect { User.login 'user@watchiot.com', '123456123123' }
          .to raise_error('Account is not valid')

      expect { User.login 'user@watchiot.com', '12345678' }
          .to_not raise_error
    end
  end

  describe 'Change username setting' do
    it 'usign patch change username fine has a 302 status code' do
      patch :account_ch_username, username: 'user_name',
            user: {username: 'new_user_name'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/new_user_name/setting/account')

      user = User.find_by_username 'user_name'
      expect(user).to be_nil
      user = User.find_by_username 'new_user_name'
      expect(user).to_not be_nil
    end

    it 'usign patch change username but it exist has a 302 status code' do
      patch :account_ch_username, username: 'user_name',
            user: {username: 'user_name_unauthorized'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('Username has already been taken')

      user = User.find_by_username 'user_name'
      expect(user).to_not be_nil
      user = User.find_by_username 'new_user_name'
      expect(user).to be_nil
    end

    it 'usign patch change username but it exist without _ has a 302 status code' do
      patch :account_ch_username, username: 'user_name',
            user: {username: 'user#name#unauthorized'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('Username has already been taken')

      user = User.find_by_username 'user_name'
      expect(user).to_not be_nil
      user = User.find_by_username 'new_user_name'
      expect(user).to be_nil
    end

    it 'usign patch change username fine has a 302 status code' do
      patch :account_ch_username, username: 'user_name',
            user: {username: 'new user@$name'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/new-user__name/setting/account')

      user = User.find_by_username 'user_name'
      expect(user).to be_nil
      user = User.find_by_username 'new-user__name'
      expect(user).to_not be_nil
    end
  end


  describe 'delete account setting' do
    it 'using delete has a 302 status code' do
      user = User.find_by_username 'user_name'
      expect(user.status).to be(true)

      delete :account_delete, username: 'user_name',
            user: {username: 'user_name'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/')

      user = User.find_by_username 'user_name'
      expect(user.status).to be(false)
    end

    it 'using delete with bad username confirmation a 302 status code' do
      user = User.find_by_username 'user_name'
      expect(user.status).to be(true)

      delete :account_delete, username: 'user_name',
             user: {username: 'user_name_not'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('The username is not valid')

      user = User.find_by_username 'user_name'
      expect(user.status).to be(true)
    end

    it 'using delete with space a 302 status code' do
      user = User.find_by_username 'user_name'
      expect(user.status).to be(true)

      Space.create!(name: 'my_space', user_id: user.id)

      delete :account_delete, username: 'user_name',
             user: {username: 'user_name'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/account')
      expect(flash[:error]).to eq('You have to transfer your spaces or delete them')

      user = User.find_by_username 'user_name'
      expect(user.status).to be(true)
    end
  end

  describe 'add members setting' do
    it 'using post add an exists user like member has a 302 status code' do
      post :team_add, username: 'user_name',
            email: {email: 'user_unauthorized@watchiot.com'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/team')

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)
    end

    it 'using post add a not exists user like member has a 302 status code' do
      email = Email.find_by_email 'user_not_exist@watchiot.com'
      expect(email).to be_nil

      post :team_add, username: 'user_name',
           email: {email: 'user_not_exist@watchiot.com'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/team')

      email = Email.find_by_email 'user_not_exist@watchiot.com'
      expect(email).to_not be_nil

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)
    end

    it 'using post add yourself like member has a 302 status code' do
      post :team_add, username: 'user_name',
           email: {email: 'user@watchiot.com'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/team')
      expect(flash[:error]).to eq('The member can not be yourself')

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(0)
    end

    it 'using post add incalid email  like member has a 302 status code' do
      post :team_add, username: 'user_name',
           email: {email: 'user_bad_email_watchiot.com'}

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/team')
      expect(flash[:error]).to eq('Email The email is not valid')

      user = User.find_by_username 'user_bad_email_watchiot.com'
      expect(user).to be_nil

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(0)
    end
  end

  describe 'remove member setting' do
    it 'using delete has a 302 status code' do
      post :team_add, username: 'user_name',
           email: {email: 'user_unauthorized@watchiot.com'}

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/team')

      delete :team_delete, username: 'user_name',
           id: user.teams.first.user_team_id

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(0)
    end

    it 'using delete try eliminate not member a 302 status code' do
      post :team_add, username: 'user_name',
           email: {email: 'user_unauthorized@watchiot.com'}

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)

      delete :team_delete, username: 'user_name',
             id: -1

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/team')
      expect(flash[:error]).to eq('The member is not valid')

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)
    end
  end

  describe 'Patch key generation setting' do
    it 'has a 302 status code' do
      user = User.find_by_username 'user_name'
      api = user.api_key.api_key

      patch :key_generate, username: 'user_name'

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name/setting/api')

      user = User.find_by_username 'user_name'
      new_api = user.api_key.api_key

      expect(api).to_not eq(new_api)
    end
  end
end

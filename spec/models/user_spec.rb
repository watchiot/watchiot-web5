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
#  countryCode            :string
#  unsubscribe_token      :string
#  receive_notif          :boolean
#

require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    before_each 'userModel'
  end

  describe 'valid create new account' do
    it 'is valid username' do
      # the password is required
      user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa')
      expect(user_new).to_not be_valid

      # nil username
      user_new = User.new(username: nil)
      expect(user_new).to_not be_valid

      expect(user_new).to_not be_valid
      # the username have to be less than 25 characters
      user_new = User.create(username: 'aaaaaaabbbbDDDDaaaaaaGGGGGGsssssssqqqqqqqEEEqqqqqq',
                             passwd: 'aaadddSSaa')
      expect(user_new.username).to eq('aaaaaaabbbbddddaaaaaaggg')

      user_new = User.create(username: 'aaaaaaabbbbDDDDaaaaaaggg',
                          passwd: 'aaadddSSaa')
      expect(user_new).to_not be_valid
    end

    it 'is valid password' do

      # the password has to be more than 8 characters
      user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa',
                          passwd: 'aaaddd')
      expect(user_new).to_not be_valid
    end

    it 'is valid username exist' do
      # the username exist
      api = ApiKey.create(api_key: SecureRandom.uuid)
      plan = Plan.create!(name: 'Free', amount_per_month: 0)

      expect { User.create!(username: 'my_user_name',
                            passwd: 'aaadddSSaa', api_key: api ,plan: plan)}
          .to raise_error(/Username has already been taken/)

      # the username exist
      expect { User.create!(username: 'my_User_NAme',
                            passwd: 'aaadddSSaa', api_key: api ,plan: plan)}
          .to raise_error(/Username has already been taken/)

      User.create!(username: 'my_User NAme',
                   passwd: 'aaadddSSaa', api_key: api ,plan: plan)

      expect { User.create!(username: 'my_User-NAme',
                            passwd: 'aaadddSSaa', api_key: api ,plan: plan)}
          .to raise_error(/Username has already been taken/)
    end

    it 'is valid create a new account' do
      # create a new acount
      ActiveJob::Base.queue_adapter = :test
      expect {
        User.create_new_account('user12@watchiot.com')
      }.to have_enqueued_job.on_queue('mailers')

      email = Email.find_by_email 'user12@watchiot.com'
      expect(email).to_not be_nil

      expect(email.user.username).to include('user12_watchiot_com')
      expect(email.user.api_key_id).to_not be_nil
    end
  end

  describe 'valid delete account' do
    it 'is valid delete a bad account' do
      expect { @user.delete_account('my_user_name_bad') }
          .to raise_error('The username is not valid')
    end

    it 'is valid delete a nil confirmation account' do
      expect { @user.delete_account(nil) }
          .to raise_error('The username is not valid')
    end

    it 'is valid delete an account with spaces' do
      # you can not delete an account with space assigned
      params = { name: 'space', description: 'space description'}
      Space.create_new_space(params, @user_two, @user_two)

      expect { @user_two.delete_account(@user_two.username) }
          .to raise_error('You have to transfer your spaces or delete them')
    end

    it 'is valid delete account' do
      expect(@user.status).to eq(true)
      @user.delete_account(@user.username)
      userDisabled = User.find_by_username 'my_user_name'
      expect(userDisabled.status).to eq(false)
    end
  end

  describe 'valid change username' do
    it 'is valid change the same username' do
      # the same username
      expect {@user.change_username 'my_user_name'}
          .to_not raise_error
    end

    it 'is valid change username' do
      # new user name
      expect {@user.change_username 'new_user_name'}
          .to_not raise_error
    end

    it 'is valid change to exist username' do
      # exist username
      expect { @user.change_username 'my_User_Name1'}
          .to raise_error(/Username has already been taken/)

      expect {@user_two.change_username 'my-user_name1'}
          .to_not raise_error

      # exist username
      expect { @user.change_username 'my User_Name1'}
          .to raise_error(/Username has already been taken/)
    end
  end

  describe 'valid register' do
    it 'is valid register' do
      # the register was correctly
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user = User.find_by_username 'new_register_user'
      expect(user).to_not be_nil
      expect(user.status).to eq(false)
      expect(user.passwd_salt).to_not be_empty
      expect(user.auth_token).to_not be_empty
      expect(user.passwd.length).to be == 60 # length of hash
      expect(user.api_key_id).to_not be_nil
      expect(user.plan_id).to_not be_nil

      emails = user.emails
      email = emails.first
      expect(email).to_not be_nil
      expect(email.email).to include('newemail@watchiot.com')
      expect(email.primary).to eq(false)
      expect(email.checked).to eq(false)

    end

    it 'is valid register with exist user' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      # invalid user
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to raise_error(/Username has already been taken/)

    end

    it 'is valid register with bad email' do
      # invalid email
      user = User.new(username: 'new_register_user1',
                      passwd: '12345678')
      email = Email.new(email: 'newemail_bad_watchiot.com')
      expect {User.register user, email}
          .to raise_error(/The email is not valid/)
    end

    it 'is valid register with nil email' do
      # invalid email

      user = User.new(username: 'new_register_user1',
                      passwd: '12345678')
      email = Email.new(email: nil)
      expect {User.register user, email}
          .to raise_error(/The email is not valid/)
    end

    it 'is valid register with empty email' do
      # invalid email
      user = User.new(username: 'new_register_user1',
                      passwd: '12345678')
      email = Email.new(email: '')
      expect {User.register user, email}
          .to raise_error(/The email is not valid/)
    end

    it 'is valid register with nil username' do
      # invalid email
      user = User.new(username: nil,
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to raise_error(/Username is too short \(minimum is 1 character\), Username can\'t be blank/)
    end

    it 'is valid register with empty username' do
      # invalid email
      user = User.new(username: '',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to raise_error(/Username is too short \(minimum is 1 character\), Username can\'t be blank/)
    end

    it 'is valid register with short password' do
      # password too short
      user = User.new(username: 'new_register_user1',
                      passwd: '123456')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to raise_error('Password has less than 8 characters.')
    end
  end

  describe 'valid change password' do
    it 'is valid change password' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      # no problem change the password
      new_user = User.find_by_username 'new_register_user'
      params = { passwd: '12345678', passwd_new: '123456789999' }
      expect { new_user.change_passwd params }
          .to_not raise_error

      # no old password now is 123456789999 not 12345678
      params = { passwd: '12345678', passwd_new: '123456789999'}
      expect { new_user.change_passwd params }
          .to raise_error('The old password is not correctly')
    end

    it 'is valid change pasword to short' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      # no problem change the password
      new_user = User.find_by_username 'new_register_user'
      params = { passwd: '12345678', passwd_new: '123'}
      expect { new_user.change_passwd params }
          .to raise_error(/Password has less than 8 characters/)
    end

    it 'is valid change nil pasword' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      # no problem change the password
      new_user = User.find_by_username 'new_register_user'
      params = { passwd: '12345678', passwd_new: nil}
      expect { new_user.change_passwd params }
          .to raise_error(/Password has less than 8 characters/)
    end


    it 'is valid change pasword with do not match' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error
    end
  end

  describe 'valid login' do
    it 'is valid login into the account with status false' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      # user status is false
      expect { User.login 'new_register_user', '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login into the account with status true' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      user_login = User.login 'new_register_user', '12345678'
      expect(user_login).to_not be_nil
      expect(user_login.username).to eq('new_register_user')
    end

    it 'is valid login with bad password' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      # bad password
      expect { User.login 'new_register_user', '123456789' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with not exist account' do
      # user does not exist
      expect { User.login 'new_register_user_1', '123456789' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with not primary email' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login 'newemail@watchiot.com', '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with primary email' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      email_login = user_new.emails.first
      user_new.active_account(email_login)

      user_login = User.login 'newemail@watchiot.com', '12345678'
      expect(user_login).to_not be_nil
      expect(user_login.username).to eq('new_register_user')
    end

    it 'is valid login with nil username' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login nil, '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with empty username' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login '', '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with nil password' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login 'new_register_user', nil }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with empty password' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login 'new_register_user', '' }
          .to raise_error('Account is not valid')
    end
  end

  describe 'valid reset the password' do
    it 'is valid reset the password with not match' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)
    end

    it 'is valid reset the password with short password' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      params = { passwd_new: '123'}
      expect { user_new.reset_passwd params }
          .to raise_error('Password has less than 8 characters')

      params = { passwd_new: nil}
      expect { user_new.reset_passwd params }
          .to raise_error('Password has less than 8 characters')
    end

    it 'is valid reset the password' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      # does not exist email like primary, not problem
      email_login = user_new.emails.first
      expect(email_login.primary).to eq(false)
      expect(email_login.checked).to eq(false)

      params = { passwd_new: 'new12345678'}
      expect { user_new.reset_passwd params }
          .to_not raise_error

      email_login = user_new.emails.first
      expect(email_login.primary).to eq(true)
      expect(email_login.checked).to eq(true)

      params = { passwd_new: 'new12345678'}

      ActiveJob::Base.queue_adapter = :test
      expect {
        user_new.reset_passwd params
      }.to have_enqueued_job.on_queue('mailers')

      # the pasword was change
      expect { User.login 'new_register_user', '12345678' }
          .to raise_error('Account is not valid')

      # login with the new passsword
      user_login = User.login user_new.username, 'new12345678'
      expect(user_login).to_not be_nil

    end

    it 'is valid reset the password with the account disabled' do
      user = User.new(username: 'new_register_user',
                      passwd: '12345678')
      email = Email.new(email: 'newemail@watchiot.com')
      expect {User.register user, email}
          .to_not raise_error

      email = Email.find_by_email 'newemail@watchiot.com'
      user_new = User.find_by_username 'new_register_user'
      email.update!(primary: true, checked: true)
      user_new.update!(status: false)

      expect { User.login user_new.username, '12345678' }
          .to raise_error('Account is not valid')

      params = { passwd_new: 'new12345678',
                 passwd_confirmation: 'new12345678'}

      # not email is sending
      ActiveJob::Base.queue_adapter = :test
      expect {
        user_new.reset_passwd params
      }.to have_enqueued_job.on_queue('mailers').exactly(0)

      # the account continue disabled
      expect(user_new.status).to eq(false)
      expect { User.login user_new.username, 'new12345678' }
          .to raise_error('Account is not valid')
    end
  end

  describe 'valid activate the account' do
    it 'is valid activate the account' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        @user.active_account @email
      }.to have_enqueued_job.on_queue('mailers')

      expect(@user.status).to eq(true)
      expect(@email.primary).to eq(true)
      expect(@email.checked).to eq(true)
    end

    it 'is valid activate the account with not belong email' do
      expect { @user.active_account @email_two }
          .to raise_error('The account can not be activate')
    end
  end

  describe 'valid invited' do
    let(:user) { User.create_new_account('user12@watchiot.com') }
    let(:email) { Email.find_by_email('user12@watchiot.com') }

    it 'is valid invited with short password' do
      # short password
      params = { username: 'new_register_user', passwd: '12345'}
      expect { user.invite params, email }
          .to raise_error('Password has less than 8 characters.')
    end

    it 'is valid invited with bad username' do
      params = { username: '', passwd: '12345678'}
      expect { user.invite params, email }
          .to raise_error(/Username is too short \(minimum is 1 character\)/)

      # username exist
      params = { username: @user.username, passwd: '12345678'}
      expect { user.invite params, email }
          .to raise_error(/Username has already been taken/)

    end

    it 'is valid invited' do
      params = { username: 'new_register_user', passwd: '12345678'}
      ActiveJob::Base.queue_adapter = :test
      expect {
        user.invite params, email
      }.to have_enqueued_job.on_queue('mailers').at_least(2)

      expect(user.auth_token).to_not be_nil
      expect(user.status).to eq(true)
      expect(email.primary).to eq(true)
      expect(email.checked).to eq(true)
    end
  end

  describe 'valid send forgot notification' do
    it 'is valid send forgot notification user not exist' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        User.send_forgot_notification 'the user do no exist'
      }.to have_enqueued_job.on_queue('mailers').exactly(0)

    end

    it 'is valid send forgot notification email not primary' do
      # the email is not set like primary
      ActiveJob::Base.queue_adapter = :test
      expect {
        User.send_forgot_notification @user.username
      }.to have_enqueued_job.on_queue('mailers')

      # the email is not set like primary buy it can recovery the password

      expect {
        User.send_forgot_notification @email.email
      }.to have_enqueued_job.on_queue('mailers')

    end

    it 'is valid send forgot notification email primary' do
      # set the email like primary
      @email.update!(primary: true, checked:true)
      ActiveJob::Base.queue_adapter = :test
      expect {
        User.send_forgot_notification @user.username
      }.to have_enqueued_job.on_queue('mailers')

      expect {
        User.send_forgot_notification @email.email
      }.to have_enqueued_job.on_queue('mailers')
    end

    it 'is valid send forgot notification two account with the same email no primary' do
      # two account with the same email no primary
      api = ApiKey.create(api_key: SecureRandom.uuid)
      plan = Plan.create!(name: 'Free', amount_per_month: 0)

      user = User.create!(username: 'my_user_name_new', passwd: '12345678', api_key: api ,plan: plan)
      Email.create!(email: 'user@watchiot.com', user_id: user.id)

      # send to the first account with only one email and not primary
      ActiveJob::Base.queue_adapter = :test
      expect {
        User.send_forgot_notification @email.email
      }.to have_enqueued_job.on_queue('mailers')
    end

    it 'is valid send forgot notification with the account disabled' do
      @user.delete_account(@user.username)
      ActiveJob::Base.queue_adapter = :test
      expect {
        User.send_forgot_notification @user.username
      }.to have_enqueued_job.on_queue('mailers').exactly(0)

      expect {
        User.send_forgot_notification @email.email
      }.to have_enqueued_job.on_queue('mailers').exactly(0)


      @user.update!(status: true)
      # it can
      expect {
        User.send_forgot_notification @user.username
      }.to have_enqueued_job.on_queue('mailers')

      expect {
        User.send_forgot_notification @email.email
      }.to have_enqueued_job.on_queue('mailers')

    end
  end

  describe 'valid omniauth' do
    it 'is valid omniauth' do
      params = { 'provider' => 'github',
                 'uid' => '12345678', 'info' =>
                     {'nickname' => 'aa', 'name' => 'aa',
                      'email' => 'omniauth@watchio.com'}}

      ActiveJob::Base.queue_adapter = :test
      expect {
        User.create_with_omniauth params
      }.to have_enqueued_job.on_queue('mailers')
    end
  end
end

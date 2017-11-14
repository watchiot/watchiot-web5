# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  email      :string(35)
#  checked    :boolean          default(FALSE)
#  primary    :boolean          default(FALSE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Email, type: :model do
  before :each do
    before_each 'emailModel'
  end

  describe 'valid add a new email' do
    it 'is valid add a new email' do
      expect( Email.count_emails(@user)).to eq(1)

      # add a new email
      email = Email.add_email(@user, 'other_user@watchiot.com')
      expect(email).to be_valid

      email = Email.add_email(@user, 'othEr_useR2@watchIot.Com')
      expect(email).to be_valid
      expect(email.email).to eq('other_user2@watchiot.com')

      expect( Email.count_emails(@user)).to eq(3)
    end

    it 'is valid add exists email' do
      # add a new email
      email = Email.add_email(@user, 'other_user@watchiot.com')
      expect(email).to be_valid

      # try to add the same email to the account
      expect { Email.add_email(@user, 'other_user@watchiot.com') }
          .to raise_error(/The email already exist in your account/)

      # try to add the same email to the account
      expect { Email.add_email(@user, 'Other_useR@watChiot.Com') }
          .to raise_error(/The email already exist in your account/)
    end

    it 'is valid add bad email' do
      # bad email
      expect { Email.add_email(@user, nil) }
          .to raise_error(/The email is not valid/)

      expect { Email.add_email(@user, 'other_use@@r@watchio@t.com') }
          .to raise_error(/The email is not valid/)
    end

    it 'is valid add email with bad user' do
      expect { Email.add_email(nil, 'other_user@watchiot.com') }
          .to raise_error(/is not a valid user/)
    end
  end

  describe 'valid primary email' do
    it 'is valid add the email like primary unchecked' do
      expect { expect( Email.primary @user, @email) }
          .to raise_error('The email has to be check')
    end

    it 'is valid add the email checked like primary' do
      # set like checked
      @email.update!(checked: true)
      # set this email like primary
      email = Email.primary @user, @email
      expect(email.primary).to eq(true)
    end

    it 'is valid add other email checked like primary' do
      # set like checked
      @email.update!(checked: true)
      # set this email like primary
      email = Email.primary @user, @email
      expect(email.primary).to eq(true)

      # add other email to the account
      other_email = Email.add_email(@user, 'other_user@watchiot.com')
      other_email.update!(checked: true)

      expect(Email.find_by_email('user@watchiot.com').primary)
          .to eq(true)

      # set this new email like primary
      new_primary = Email.primary @user, other_email

      expect(new_primary.primary).to eq(true)
      # this email already left to be primary
      expect(Email.find_by_email('user@watchiot.com')
                 .primary).to eq(false)
    end

    it 'is valid add the email like primary being primary in other account' do
      email = Email.add_email(@user, @email_two.email)
      email.update!(checked: true)

      # try to set like primary an email primary in other account
      expect { Email.primary @user, email }
          .to raise_error('The email is primary in other account')
    end
  end

  describe 'valid remove email' do
    it 'is valid remove the unique email' do
      # you can not delete your unique email in your account
      expect { Email.remove_email @user, @email.id }
          .to raise_error('You can not delete the only email with you have in your account')
    end

    it 'is valid remove an primary email' do
      @email.update!(checked: true)
      # set this email like primary
      email = Email.primary @user, @email
      expect(email.primary).to eq(true)

      # set the other email like primary
      email = Email.add_email(@user, 'user12@watchiot.com')
      email.update!(checked: true)

      expect { Email.remove_email @user, @email.id }
          .to raise_error('The email can not be primary')
    end

    it 'is valid remove an not primary email' do
      # set the other email like primary
      email = Email.add_email(@user, 'user12@watchiot.com')
      email.update!(checked: true)

      email = Email.primary @user, email
      expect(email.primary).to eq(true)

      expect { Email.remove_email @user, @email.id}
          .to_not raise_error

      expect { Email.remove_email @user, email.id }
          .to raise_error('You can not delete the only email with you have in your account')
    end
  end

  describe 'valid to send verification' do
    it 'is valid to send verification check email' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        Email.send_verify(@user, @email.id)
      }.to have_enqueued_job.on_queue('mailers')
    end

    it 'is valid to send verification uncheck email' do
      expect { Email.send_verify(@user_two, @email_two.id) }
          .to raise_error('The email has to be uncheck')
    end
  end

  describe 'valid to can active an account by invitation' do
    it 'is valid to active the email like primary' do
      expect { Email.to_activate_by_invitation @user, @email.email }
          .to_not raise_error
    end

    it 'is valid to active the email not valid' do
      expect { Email.to_activate_by_invitation @user, 'aass@watchiot.com' }
          .to raise_error('The email is not valid')

      expect { Email.to_activate_by_invitation @user, @email_two.email }
          .to raise_error('The email is not valid')

      expect { Email.to_activate_by_invitation @user_two, @email_two.email }
          .to raise_error('The email is not valid')

      # add email two but like it is primary in other account
      # we can not add to activate
      Email.add_email(@user, @email_two.email)
      expect { Email.to_activate_by_invitation @user, @email_two.email }
          .to raise_error('The email is not valid')
    end
  end

  describe 'valid checked the email' do
    it 'is valid checked the email with not exist' do
      expect { Email.to_check @user, 'myemail@watchiot.com' }
          .to raise_error('The email is not valid')
    end

    it 'is valid checked the email' do
      email = Email.to_check @user, @email.email
      expect(email.email).to eq(@email.email)
    end
  end

  describe 'valid find email not primary to forgot password' do
    it 'is valid one email unique and not primary' do
      # only one email and one account
      email = Email.find_email_forgot @user.emails.first.email
      expect(email).to_not be_nil
    end

    it 'is valid find into two account with the same email no primary' do
      api = ApiKey.create(api_key: SecureRandom.uuid)
      plan = Plan.create!(name: 'Free', amount_per_month: 0)

      user = User.create!(username: 'my_user_name_new',
                          passwd: '12345678', api_key: api ,plan: plan)
      Email.create!(email: 'user@watchiot.com', user_id: user.id)

      # two account with the same email no primary
      email = Email.find_email_forgot 'user@watchiot.com'
      expect(email).to_not be_nil
      expect(email.email).to eq(@user.emails.first.email)
    end

    it 'is valid find into two account with the same email but @user have an email like primary' do
      # add new email to @user like primary
      Email.create!(email: 'user_new@watchiot.com',
                    user: @user,
                    primary: true,
                    checked: true)

      api = ApiKey.create(api_key: SecureRandom.uuid)
      plan = Plan.create!(name: 'Free', amount_per_month: 0)

      user = User.create!(username: 'my_user_name_new',
                          passwd: '12345678', api_key: api ,plan: plan)
      Email.create!(email: 'user@watchiot.com', user_id: user.id)

      email = Email.find_email_forgot 'user@watchiot.com'
      expect(email).to_not be_nil
      expect(email.email).to eq(user.emails.first.email)
    end
  end
end

require 'rails_helper'

RSpec.describe Notifier, type: :mailer do
  before :each do
    before_each 'notif'
  end

  describe 'Send signup email' do
    let(:mail) { Notifier
           .send_signup_email('email@watchiot.com', @user, '123456789') }

    it 'renders the headers' do
      expect_sub_to_from 'WatchIoT Account Activation'
    end

    it 'renders the body' do
      body = mail.body.encoded
      expect(body).to match('/active/123456789')
    end
  end

  describe 'Send signup verify email' do
    let(:mail) { Notifier
           .send_signup_verify_email('email@watchiot.com', @user) }

    it 'renders the headers' do
      expect_sub_to_from 'Welcome to WatchIoT!!'
    end

    it 'renders the body' do
      expect(mail.body.encoded)
          .to match('Hi my_user_name!')
      expect(mail.body.encoded)
          .to match('Congratulations on your new <b>WatchIoT</b> account!')
    end
  end

  describe 'Send transfer space email' do
    let(:mail) { Notifier
           .send_transfer_space_email('email@watchiot.com', @user, @space) }

    it 'renders the headers' do
      expect_sub_to_from 'Transferred space for you!!'
    end

    it 'renders the body' do
      expect(mail.body.encoded)
          .to match('<br/><br/> the space <b>my_space</b> was transferred for you!')

      expect(mail.body.encoded)
          .to match('by <strong>my_user_name\(user@watchiot.com\)</strong>')
    end
  end

  describe 'Send new team email' do
    let(:mail) { Notifier
           .send_new_team_email('email@watchiot.com', @user, @user_two) }

    it 'renders the headers' do
      expect_sub_to_from 'Your belong a new team!!'
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('<h1>Hi my_user_name1</h1>')
      expect(mail.body.encoded)
          .to match('You have been invited by <strong>my_user_name\(user@watchiot.com\)</strong> to join a new team on <b>WatchIoT</b>.')
    end
  end

  describe 'Send create user email' do
    let(:mail) { Notifier
           .send_create_user_email('email@watchiot.com', @user, '123456789') }

    it 'renders the headers' do
      expect_sub_to_from 'Your have been invited to WatchIoT!!'
    end

    it 'renders the body' do
      expect(mail.body.encoded)
          .to match('You have been invited to join <b>WatchIoT</b>.')
      expect(mail.body.encoded).to match('/invite/123456789')
    end
  end

  describe 'Send forget passwd email' do
    let(:mail) { Notifier
           .send_forget_passwd_email('email@watchiot.com', @user, '123456789') }

    it 'renders the headers' do
      expect_sub_to_from 'WatchIoT password reset!!'
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi my_user_name,')
      expect(mail.body.encoded).to match('/reset/123456789')
    end
  end

  describe 'Send verify email' do
    let(:mail) { Notifier
           .send_verify_email('email@watchiot.com', @user, '123456789') }

    it 'renders the headers' do
      expect_sub_to_from 'WatchIoT verify email!!'
    end

    it 'renders the body' do
      body = mail.body.encoded
      expect(body).to match('Hi my_user_name!')
      expect(body).to match('/verify_email/123456789')
    end
  end

  describe 'Send reset passwd email' do
    let(:mail) { Notifier
           .send_reset_passwd_email('email@watchiot.com', @user) }

    it 'renders the headers' do
      expect_sub_to_from 'WatchIoT password reset correctly!!'
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi my_user_name!')
      expect(mail.body.encoded)
          .to match('<p>The password was restarted correctly.</p>')
    end
  end
end

def expect_sub_to_from(subject)
  expect(mail.subject).to eq(subject)
  expect(mail.to).to eq(['email@watchiot.com'])
  expect(mail.from).to eq(['info@watchiot.com'])
end

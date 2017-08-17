class Notifier < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(email, user, token)
    @user = user
    @token = token
    puts 'aaaa'
    mail( :to => email,
          :subject => 'WatchIoT Account Activation' )
  end

  # send a transfer space email to the user
  def send_signup_verify_email(email, user)
    @user = user
    mail( :to => email,
          :subject => 'Welcome to WatchIoT!!')
  end

  # send a transfer space email to the user
  def send_transfer_space_email(email, user, space)
    @user = user
    @space = space
    mail( :to => email,
          :subject => 'Transferred space for you!!')
  end

  # send a new team member
  def send_new_team_email(email, user, user_member)
    @user = user
    @user_member = user_member
    mail( :to => email,
          :subject => 'Your belong a new team!!')
  end

  # send a new team member
  def send_create_user_email(email, token)
    @token = token
    mail( :to => email,
          :subject => 'Your have been invited to WatchIoT!!')
  end

  # send forget passwd token
  def send_forget_passwd_email(email, user, token)
    @user = user
    @token = token
    mail( :to => email,
          :subject => 'WatchIoT password reset!!')
  end

  # send forget passwd token
  def send_verify_email(email, user, token)
    @user = user
    @token = token
    mail( :to => email,
          :subject => 'WatchIoT verify email!!')
  end

  # send forget passwd token
  def send_reset_passwd_email(email, user)
    @user = user
    mail( :to => email,
          :subject => 'WatchIoT password reset correctly!!')
  end
end

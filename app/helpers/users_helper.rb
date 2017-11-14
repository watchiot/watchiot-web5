require "digest/md5"

module UsersHelper
  ##
  # This method return the primary email
  #
  def user_email(user)
    email = Email.find_primary(user).take
    email.email unless email.nil?
  end

  ##
  # This method return the username
  #
  def user_name(user_id)
    user = User.find(user_id)
    user.username unless user.nil?
  end

  def gravatar(email)
    'http://gravatar.com/avatar/' + Digest::MD5.hexdigest(email).to_s + '?s=200'
  end
end

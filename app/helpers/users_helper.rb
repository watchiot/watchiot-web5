module UsersHelper
  ##
  # This method return the primary email
  #
  def user_email(user_id)
    email = Email.find_primary_by_user(user_id).take
    email.email unless email.nil?
  end

  ##
  # This method return the username
  #
  def user_name(user_id)
    user = User.find(user_id)
    user.username unless user.nil?
  end
end
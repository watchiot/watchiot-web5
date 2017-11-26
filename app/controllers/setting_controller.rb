##
# Setting controller
#
class SettingController < ApplicationController
  layout 'dashboard'

  before_action :allow_me

  ##
  # Get /:username/setting
  #
  def show
    @email = Email.new
    @emails = Email.find_emails(@user)
    @teams = Team.my_teams(@user)
    @teams_belong = Team.belong_to @user
    @countries = Country.all
    @in = valid_tab? ? params[:val] : ''
  end

  ##
  # Patch /:username/setting/profile
  #
  def profile
    redirect_to '/' + @user.username + '/setting'

    @user.update!(profile_params)

    flash_log('Edit the profile setting', 'Profile was updated correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Post /:username/setting/account/add/email
  #
  def account_add_email
    redirect_to '/' + me.username + '/setting/account'

    email = Email.add_email(@user, email_params[:email])

    flash_log('Add new email <b>' + email .email + '</b>',
                        'Added a new email correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  ##
  # Delete /:username/setting/account/remove/email/:id
  #
  def account_remove_email
    redirect_to '/' + @user.username + '/setting/account'

    email = Email.find_by_id(params[:id])
    Email.remove_email(@user, email)

    flash_log('Delete email <b>' + email.email + '</b>',
              'The email was deleted correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  ##
  # Get /:username/setting/account/primary/email/:id
  #
  def account_primary_email
    redirect_to '/' + @user.username + '/setting/account'

    email = Email.find_by_id params[:id]
    Email.primary(@user, email)

    flash_log('Set email <b>' + email.email + '</b> like primary',
              'The email was setted like primary correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  ##
  # Get /:username/setting/account/verify/email/:id
  #
  def account_verify_email
    redirect_to '/' + @user.username + '/setting/account'

    email = Email.find_by_id params[:id]
    Email.send_verify(@user, email)

    flash_log('Send to verify the email <b>' + email.email + '</b>',
              'The email to verify was sended correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  ##
  # Patch /:username/setting/account/password
  #
  def account_ch_password
    redirect_to '/' + @user.username + '/setting/account'

    @user.change_passwd(passwd_params)

    flash_log('Change password', 'The password was changed correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  ##
  # Patch /:username/setting/account/username
  #
  def account_ch_username
    old_username = @user.username
    @user.change_username username_params[:username]

    flash_log('Change username <b>' + old_username + '</b> by <b>' + username_params[:username] + '</b>',
              'The new username was saved correctly')

    redirect_to '/' + @user.username + '/setting/account'
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + old_username + '/setting/account'
  end

  ##
  # Delete /:username/setting/account/delete
  #
  def account_delete
    @user.delete_account username_params[:username]

    cookies.clear

    redirect_to root_url
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/setting/account'
  end

  ##
  # Post /:username/setting/team/add
  #
  def team_add
    redirect_to '/' + @user.username + '/setting/team'
    
    email = email_params[:email]
    Team.add_member @user, email

    flash_log('Adding a new member <b>' + email + '</b>',
              'The member was added correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  ##
  # Delete /:username/setting/team/delete/:id
  #
  def team_delete
    redirect_to '/' + @user.username + '/setting/team'

    team_user = User.find_by_id(params[:id])
    Team.remove_member @user, team_user

    email = Email.find_primary(team_user).take || Email.find_emails(team_user).take

    flash_log('Delete a member <b>' + email.email + '</b>',
              'The member was deleted correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  ##
  # Patch /:username/setting/key/generate
  #
  def key_generate
    redirect_to '/' + @user.username + '/setting/api'

    ApiKey.generate @user

    flash_log('Change api key', 'The api key was changed correctly')
  rescue => ex
    flash[:error] = clear_exception ex.message
  end

  private

  ##
  # Filter method
  # if the request was doing for the user login
  #
  def allow_me
    @user = User.find_by_username(params[:username]) || not_found
    @user if auth? && me.username == @user.username || unauthorized
    @spaces = Space.find_spaces(@user)
  rescue Errors::UnauthorizedError
    render_401
  end

  ##
  # Validate tabs when redirect is throw
  #
  def valid_tab?
    %w(account team api).any? { |word|  params[:val] == word }
  end

  ##
  # Set flash and log
  #
  def flash_log(log_description, msg)
    save_log log_description, 'Setting', @user.id
    flash[:notice] = msg
  end

  ##
  # Profile params
  #
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :country_code,
                                 :address, :phone, :receive_notif, :receive_notif_last_new)
  end

  ##
  # Email params
  #
  def email_params
    params.require(:email).permit(:email)
  end

  ##
  # Email id params
  #
  def email_id_param
    params.require(:email).permit(:id)
  end

  ##
  # Passwd change params
  #
  def passwd_params
    params.require(:user).permit(:passwd, :passwd_new, :passwd_confirmation)
  end

  ##
  # Passwd change params
  #
  def username_params
    params.require(:user).permit(:username)
  end
end

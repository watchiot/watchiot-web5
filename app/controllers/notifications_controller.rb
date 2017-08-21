##
# Notification controller
#
class NotificationsController < ApplicationController

  before_action :find_reset_user_by_token, :only => [:reset, :do_reset]
  before_action :find_active_user_by_token, :only => :active
  before_action :find_verify_email_by_token, :only => :verify_email
  before_action :find_invite_user_by_token, :only => [:invite, :do_invite]

  ##
  # Get /active
  #
  def active
    @user.active_account @email
    @verifyClient.destroy!

    cookies[:auth_token] = @user.auth_token
    redirect_to '/' + @user.username
  rescue StandardError => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/'
  end

  ##
  # GET /forgot
  #
  def forgot
    @user = me || User.new
    render 'users/forgot'
  end

  ##
  # Post /forgot
  # never show if the username or email exist in the system, security reason
  #
  def forgot_notification
    User.send_forgot_notification user_forget_params[:username]
    render 'users/forgot_notification'
  end

  ##
  # Get /reset/:token
  #
  def reset
    @token = params[:token]
    render 'users/reset'
  end

  ##
  # Patch /reset/:token
  #
  def do_reset
    @user.reset_passwd user_reset_params
    @verifyClient.destroy!

    cookies.clear
    redirect_to '/login'
  rescue StandardError => ex
    flash.now[:error] = clear_exception ex.message
    render 'users/reset'
  end

  ##
  # Get /verify_email
  #
  def verify_email
    @email.verify_email
    @verifyClient.destroy!
    render 'users/verify_email'
  rescue => ex
    flash.now[:error] = clear_exception ex.message
    render 'users/verify_email'
  end

  ##
  # Get /invited
  #
  def invite
    @token = params[:token]
    render 'users/invited'
  end

  ##
  # Patch /do_invited
  #
  def do_invite
    email = Email.to_activate_by_invitation(@verifyClient.user_id, @verifyClient.data)
    @user.invite user_params, email
    @verifyClient.destroy!

    cookies[:auth_token] = @user.auth_token
    redirect_to '/' + @user.username
  rescue => ex
    flash.now[:error] = clear_exception ex.message
    render 'users/invited'
  end

  private

  ##
  # Get a token
  #
  def find_reset_user_by_token
    find_by_concept 'reset', params[:token]
  end

  ##
  # Get a token
  #
  def find_active_user_by_token
    find_by_concept 'register', params[:token]
    @email = Email.to_activate_by_invitation(@verifyClient.user_id, @verifyClient.data) ||
        not_found
  rescue
    not_found
  end

  ##
  # Get a token
  #
  def find_verify_email_by_token
    find_by_concept 'verify_email', params[:token]
    @email = Email.to_check(@verifyClient.user_id, @verifyClient.data) ||
        not_found
  rescue
    not_found
  end

  ##
  # Get a token
  #
  def find_invite_user_by_token
    find_by_concept 'invited', params[:token]
  end

  ##
  # Get a token
  #
  def find_by_concept(concept, token)
    @verifyClient = VerifyClient.find_by_token_and_concept(token, concept)
                                .take || not_found
    @user = User.find(@verifyClient.user_id) || not_found
  end

  ##
  # User foget params
  #
  def user_forget_params
    params.require(:user).permit(:username)
  end

  ##
  # User params
  #
  def user_reset_params
    params.require(:user).permit(:passwd_new, :passwd_confirmation)
  end

  ##
  # User params
  #
  def user_params
    params.require(:user).permit(:passwd, :passwd_confirmation, :username)
  end
end

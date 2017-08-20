##
# User controller
#
class UsersController < ApplicationController

  ##
  # POST /do_register
  #
  def do_register
    @user = User.new(user_params)
    @email = Email.new(email: params[:email])

    User.register(@user, @email)

    render 'need_verify_notification'
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/#get-started'
  end

  ##
  # POST /login
  #
  def do_login
    @user = User.new(user_params)
    user = User.login(user_params[:username], user_params[:passwd])

    cookies[:auth_token] = user.auth_token unless params[:remember_me]
    cookies.permanent[:auth_token] = user.auth_token if params[:remember_me]

    redirect_to '/' + user.username
  rescue => ex
    flash.now[:error] = clear_exception ex.message
    redirect_to '/#get-started'
  end

  ##
  # Get /do_omniauth
  #
  def do_omniauth
    auth = request.env['omniauth.auth']
    user = User.omniauth(auth)

    cookies[:auth_token] = user.auth_token

    redirect_to '/' + user.username
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to 'login'
  end

  ##
  # Get /logout
  #
  def logout
    cookies.clear

    redirect_to root_url
  end

  private

  ##
  # User params
  #
  def user_params
    params.require(:user).permit(:passwd, :username, :remember_me)
  end
end

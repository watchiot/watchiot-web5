class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :auth?
  helper_method :me
  helper_method :me_user_email
  helper_method :me_api_key
  helper_method :param_user

  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActionController::BadRequest, with: :render_400

  private

  ##
  # If exist user authenticate
  #
  def auth?
    me != nil
  end

  ##
  # This method return the user authenticate or nil
  #
  def me
    cookie = cookies[:auth_token]
    @current_user ||= User.find_by_auth_token( cookie) if cookie
  end

  ##
  # This method return the client primary email
  #
  def me_user_email
    email = Email.find_primary_by_user(me.id).take
    return '' if email.nil?
    email.email
  end


  ##
  # This method return the client api key
  #
  def me_api_key
    api_key = ApiKey.find(me.api_key_id) unless me.nil?
    api_key.api_key || ''
  end

  ##
  # This method return the query string username
  #
  def param_user
    params[:username]
  end

  ##
  # Throw RoutingError exception
  #
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  ##
  # Throw RoutingError exception
  #
  def bad_request
    raise ActionController::BadRequest.new('Bad request')
  end

  ##
  # Throw RoutingError exception
  #
  def unauthorized
    raise Errors::UnauthorizedError.new('Unauthorized')
  end

  ##
  # Render not found page
  #
  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  ##
  # Render unauthorized page
  #
  def render_401
    render file: "#{Rails.root}/public/401.html", layout: false, status: 401
  end

  ##
  # Render bad request page
  #
  def render_400
    render file: "#{Rails.root}/public/400.html", layout: false, status: 400
  end

  ##
  # Save logs by actions
  #
  def save_log(description, action, owner_user_id)
    Log.save_log(description,  action, owner_user_id, me.id)
  end

  ##
  # This method delete the chain Validation failed:
  # render by validation exceptions
  #
  def clear_exception(msg)
    msg.gsub(/Validation failed: /i, '')
  end

  ##
  # if the request was doing for the user login or an user team
  #
  def allow
    raise Errors::UnauthorizedError if me == nil

    @user = User.find_by_username(params[:username]) || not_found
    @user if auth? && @user.username == me.username ||
          Team.find_member(@user.id, me.id).exists? || unauthorized
    @spaces = Space.find_by_user_order(@user.id).all
  rescue Errors::UnauthorizedError
    render_401
  end

  ##
  # Get acces to space
  #
  def allow_space
    @space = Space.find_by_user_and_name(@user.id, params[:namespace]).take ||
        not_found
  end

  ##
  # Get acces to project
  #
  def allow_project
    @project = Project.find_by_user_space_and_name(
        @user.id, @space.id,
        params[:nameproject]).take || not_found

    @tokens = Project.token
  end
end

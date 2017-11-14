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
    @current_user ||= User.find_by_auth_token(cookie) if cookie
  end

  ##
  # This method return the client primary email
  #
  def me_user_email
    email = Email.find_primary_by_user(me.id).take if auth?
    email.email || ''
  end


  ##
  # This method return the client api key
  #
  def me_api_key
    api_key = ApiKey.find(me.api_key_id) if auth?
    api_key.api_key || ''
  end

  ##
  # This method return the query string username
  #
  def param_user
    params[:username]
  end

  ##
  # Save logs by actions
  #
  def save_log(description, action, owner_user_id)
    Log.save_log(description, action, owner_user_id, me.id)
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
    @user = User.find_by_username(params[:username]) || not_found

    is_not_me = @user.username != me.username
    i_am_not_team_member = Team.find_member(@user.id, me.id).empty?

    unauthorized if !auth? || (is_not_me && i_am_not_team_member)

    @spaces = Space.find_spaces(@user.id).all
  rescue Errors::UnauthorizedError
    render_401
  end

  ##
  # Get acces to space
  #
  def allow_space
    name = params[:namespace]
    @space = Space.find_space(@user.id, name).take || not_found
  end

  ##
  # Get acces to project
  #
  def allow_project
    name = params[:nameproject]
    @project = Project.find_project(@user.id, @space.id, name).take || not_found

    # parser token
    @parse_token = Project.token
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
  # Render bad request page
  #
  def render_400
    render file: "#{Rails.root}/public/400.html", layout: false, status: 400
  end

  ##
  # Render unauthorized page
  #
  def render_401
    render file: "#{Rails.root}/public/401.html", layout: false, status: 401
  end

  ##
  # Render not found page
  #
  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
end

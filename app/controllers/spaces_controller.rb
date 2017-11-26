##
# Space controller
#
class SpacesController < ApplicationController
  layout 'dashboard'

  before_action :allow
  before_action :allow_space, :except => [:index, :create]

  ##
  # Get /:username/spaces
  #
  def index
    @space = Space.new
  end

  ##
  # Get /:username/:namespace
  #
  def show
    @project = Project.new
  end

  ##
  # Post /:username/create
  #
  def create
    space = Space.create_new_space(space_create_params, @user, me)

    flash_log('Create the space <b>' + space.name + '</b>',
              'Space was created correctly')

    redirect_to '/' + @user.username + '/' + space.name
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/spaces'
  end

  ##
  # Patch /:username/:namespace
  #
  def edit
    @space.update_description(space_edit_params[:description])
    @project = Project.new

    flash_log('Edit the space <b>' + @space.name + '</b>',
                        'Space was edited correctly')

    redirect_to '/' + @user.username + '/' + @space.name
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/' + @space.name
  end

  ##
  # Get /:username/:namespace/setting
  #
  def setting
    @teams = Team.my_teams @user
  end

  ##
  # Patch /:username/:namespace/setting/change
  # Change space name
  #
  def change
    old_name = @space.name
    @space.update_namespace(space_name_params[:name])
    new_name = @space.name
    flash_log('Change name space <b>' + old_name + '</b> by <b>' + new_name + '</b>',
              'The namespace was changed correctly')

    redirect_to '/' + @user.username + '/' + new_name + '/setting'
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/' + old_name + '/setting'
  end

  ##
  # Patch /:username/:namespace/setting/transfer
  #
  def transfer
    user_member = User.find_by_id(params[:user_team_id])
    email_member = Email.find_primary(user_member).take
    my_email = Email.find_primary(@user).take

    @space.transfer @user, user_member, email_member

    flash_log('Change the owner of space <b>' + @space.name +
                '</b> to <b>' + email_member.email + '</b>',
                'The space was transferred correctly')

    flash_log('Change the owner of space <b>' + @space.name +
                '</b> from <b>' + my_email.email + '</b> to you!',
                'The space was transferred correctly', params[:user_team_id])

    redirect_to '/' + @user.username + '/spaces'
  rescue => ex
    flash[:error] = clear_exception parser_transfer_error(ex.message)
    redirect_to '/' + @user.username + '/' + @space.name + '/setting'
  end

  ##
  # Delete /:username/:namespace/setting/delete
  #
  def delete
    @space.delete_space(space_name_params[:name])

    flash_log('Delete space <b>' + space_name_params[:name] + '</b>',
              'The space was deleted correctly')
              
    redirect_to '/' + @user.username + '/spaces'
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/' + @space.name + '/setting'
  end

  private

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_create_params
    params.require(:space).permit(:name, :description)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_name_params
    params.require(:space).permit(:name)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_edit_params
    params.require(:space).permit(:name, :description)
  end

  ##
  # Set flash and log
  #
  def flash_log(log_description, msg, userId = @user.id)
    save_log log_description, 'Space', userId
    flash[:notice] = msg
  end

  ##
  # parse transfer error
  #
  def parser_transfer_error(msg)
    return 'The team member has a space with this name' if
        msg == 'Validation failed: Name You have a space with this name'
    msg
  end
end

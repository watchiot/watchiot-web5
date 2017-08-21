##
# Dashboard controller
#
class DashboardController < ApplicationController
  layout 'dashboard'

  before_action :allow

  ##
  # Get /:username
  #
  def show
    @space = Space.new
    @logs = Log.where(user_id: @user.id).limit(20)
                .order(created_at: :desc)
  end
end

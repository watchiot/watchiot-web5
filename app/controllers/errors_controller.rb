##
# Error controller
#
class ErrorsController < ApplicationController
  ##
  # Get 404
  #
  def routing
    render_404
  end
end

##
# Home controller
#
class HomeController < ApplicationController

  ##
  # Get /
  #
  def index
    @user = User.new
    #@email = Email.new

    @descrips = Descrip.where(lang: 'en').all
    @faqs = Faq.where(lang: 'en').all
  end
end

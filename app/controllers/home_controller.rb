##
# Home controller
#
class HomeController < ApplicationController

  ##
  # Get /
  #
  def index
    @user = User.new

    @descrips = Descrip.where(lang: 'en').all
    @faqs = Faq.where(lang: 'en').all
  end

  def terms_and_conditions
  end
end

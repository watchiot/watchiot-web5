##
# Home controller
#
class HomeController < ApplicationController
  ##
  # Get /
  #
  def index
    @faqs = Faq.where(lang: 'en').all
    @descrips = Descrip.where(lang: 'en').all
    @contactus = ContactUs.new
  end

  ##
  # POST /contactus
  #
  def contact
    redirect_to root_url + '#contactus'

    @contactus = ContactUs.create(contact_params)
    flash[:success] = 'Thank you for contact us!'
  rescue => ex
    flash[:error] = 'Exist a problem!'
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact_us).permit(:email, :subject, :body)
  end
end

class ApplicationMailer < ActionMailer::Base
  default from: 'info@watchiot.com'
  add_template_helper(UsersHelper)
  
  layout 'mailer'
end

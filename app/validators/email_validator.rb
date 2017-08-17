##
# Email format validator
#
class EmailValidator < ActiveModel::EachValidator
  ##
  # Validator
  #
  def validate_each(record, attribute, value)
    record.errors[attribute] << ('The email is not valid') unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

end

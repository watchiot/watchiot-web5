# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  email      :string(35)
#  checked    :boolean          default(FALSE)
#  primary    :boolean          default(FALSE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Email < ApplicationRecord
  belongs_to :user

  validates :email, email: true , presence: true
  validates_uniqueness_of :email, scope: [:user_id],
                          message: 'The email already exist in your account'

  before_validation :downcase_email

  scope :find_by_user, -> user_id {
          where('user_id = ?', user_id).order(primary: :desc)
        }

  scope :count_by_user, -> user_id {
          where('user_id = ?', user_id).count
        }

  scope :find_primary_by_user, -> user_id {
          where('user_id = ?', user_id).
          where(primary: true)
        }

  scope :find_by_user_and_by_id, -> user_id, id {
          where('user_id = ?', user_id).
          where('id = ?', id) if id.present?
        }

  scope :find_primary_by_email, -> email {
          where('email = ?', email.downcase).
          where(primary: true) if email.present?
        }

  scope :find_by_user_and_by_email, -> user_id, email {
          where('user_id = ?', user_id).
          where('email = ?', email.downcase) if email.present?
        }

  ## -------------------- Instance method ----------------------- ##

  ##
  # Update the email record
  #
  def save_email(user, checked)
    self.update!(user_id: user.id, checked: checked, primary: checked)
  end

  ##
  # Set the check email field like true
  #
  def verify_email()
    self.update!(checked: true)
  end

  ## ---------------------- Class method ----------------------- ##

  ##
  # Add an email to the account unprimary waiting for verification
  #
  def self.add_email(user_id, email)
    raise StandardError, 'is not a valid user' unless
        User.where('id=?', user_id).exists?

    Email.create!(email: email, user_id: user_id)
  end

  ##
  # Set this email id like primary
  #
  def self.primary(user, email_id)
    new_email_primary = find_by_user_and_by_id(user.id, email_id).take

    raise StandardError, 'The email is not valid' if new_email_primary.nil?
    raise StandardError, 'The email has to be check' unless new_email_primary.checked?
    raise StandardError, 'The email already is primary in your account' if new_email_primary.primary
    raise StandardError, 'The email is primary in other account' if
          Email.find_primary_by_email(new_email_primary.email).exists?

    # set like not primary if exist the current primary email
    old_email_primary = Email.find_primary_by_user(user.id).take

    ActiveRecord::Base.transaction do
      old_email_primary.update!(primary: false) unless old_email_primary.nil?
      new_email_primary.update!(primary: true)
    end

    Notifier.send_not_primary_email(old_email_primary.email, user).deliver_later unless old_email_primary.nil?   
    Notifier.send_new_primary_email(new_email_primary.email, user).deliver_later

    new_email_primary
  end

  ##
  # Remove an email unprimary
  #
  def self.remove_email(user_id, email_id)
    email = find_by_user_and_by_id(user_id, email_id).take

    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'You can not delete the only email with you have '\
                         'in your account' if Email.count_by_user(user_id) == 1
    raise StandardError, 'The email can not be primary' if email.primary?

    email.destroy!
  end

  ##
  # Send the verification email
  #
  def self.send_verify(user_id, email_id)
    email = find_by_user_and_by_id(user_id, email_id).take

    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email has to be uncheck' if email.checked?

    token = VerifyClient.token(user_id, email.email, 'verify_email')
    Notifier.send_verify_email(email.email, email.user, token).deliver_later

    email
  end

  ##
  # Define if the email can checked like primary
  #
  def self.to_activate_by_invitation(user_id, email_s)
    email = Email.find_primary_by_email(email_s).take
    raise StandardError, 'The email is not valid' unless email.nil?

    email = Email.find_by_user_and_by_email(user_id, email_s).take
    raise StandardError, 'The email is not valid' if email.nil?

    email
  end

  ##
  # by other user
  #
  def self.to_check(user_id, email_s)
    email = Email.find_by_user_and_by_email(user_id, email_s).take
    raise StandardError, 'The email is not valid' if email.nil?

    email
  end

  ##
  # find an email not primary valid
  #
  def self.find_email_forgot (email_s)
    emails = Email.where(email: email_s.downcase).all

    return if emails.nil? || emails.empty?
    return emails.first if emails.length == 1

    # find a registered account by never activate him account
    emails.each do |email|
      user = email.user
      return email if user.emails.length == 1 && !email.primary?
    end
  end

  protected

  ##
  # Downcase email
  #
  def downcase_email
    self.email = self.email.downcase unless self.email.nil?
  end
end

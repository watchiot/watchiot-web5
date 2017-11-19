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

  scope :find_emails, -> user {
          where('user_id = ?', user.id).order(primary: :desc) unless user.nil?
        }

  scope :count_emails, -> user {
          where('user_id = ?', user.id).count unless user.nil?
        }

  scope :find_email_by_email, -> user, email_s {
          where('user_id = ?', user.id).
          where('email = ?', email_s.downcase) if !user.nil? && email_s.present?
        }

  scope :find_primary, -> user {
          where('user_id = ?', user.id).
          where(primary: true) unless user.nil?
        }

  scope :find_primary_by_email, -> email_s {
          where('email = ?', email_s.downcase).
          where(primary: true) if email_s.present?
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
  def verify_email
    self.update!(checked: true)
  end

  ## ---------------------- Class method ----------------------- ##

  ##
  # Add an email to the account unprimary waiting for verification
  #
  def self.add_email(user, email_s)
    raise StandardError, 'is not a valid user' if user.nil?

    Email.create!(user: user, email: email_s)
  end

  ##
  # Set this email id like primary
  #
  def self.primary(user, primary_email)
    valid_email = !primary_email.nil? && !user.nil? && primary_email.user_id == user.id

    raise StandardError, 'The email is not valid' unless valid_email
    raise StandardError, 'The email has to be check' unless primary_email.checked?
    raise StandardError, 'The email already is primary in your account' if primary_email.primary
    raise StandardError, 'The email is primary in other account' if
          Email.find_primary_by_email(primary_email.email).exists?

    # set like not primary if exist the current primary email
    old_primary_email = Email.find_primary(user).take

    ActiveRecord::Base.transaction do
      old_primary_email.update!(primary: false) unless old_primary_email.nil?
      primary_email.update!(primary: true)
    end

    Notifier.send_not_primary_email(old_primary_email.email, user).deliver_later unless old_primary_email.nil?
    Notifier.send_new_primary_email(primary_email.email, user).deliver_later

    primary_email
  end

  ##
  # Remove an email unprimary
  #
  def self.remove_email(user, email)
    valid_email = !email.nil? && !user.nil? && email.user_id == user.id

    raise StandardError, 'The email is not valid' unless valid_email
    raise StandardError, 'You can not delete the only email with you have '\
                         'in your account' if Email.count_emails(user) == 1
    raise StandardError, 'The email can not be primary' if email.primary?

    email.destroy!
  end

  ##
  # Send the verification email
  #
  def self.send_verify(user, email)
    valid_email = !email.nil? && !user.nil? && email.user_id == user.id

    raise StandardError, 'The email is not valid' unless valid_email
    raise StandardError, 'The email has to be uncheck' if email.checked?

    token = VerifyClient.token(user, email.email, 'verify_email')
    Notifier.send_verify_email(email.email, email.user, token).deliver_later
  end

  ##
  # Define if the email can checked like primary
  #
  def self.to_activate_by_invitation(user, email_s)
    email = Email.find_primary_by_email(email_s).take
    raise StandardError, 'The email is not valid' unless email.nil?

    email = Email.find_email_by_email(user, email_s).take
    raise StandardError, 'The email is not valid' if email.nil?

    email
  end

  ##
  # by other user
  #
  def self.to_check(user, email_s)
    email = Email.find_email_by_email(user, email_s).take
    raise StandardError, 'The email is not valid' if email.nil?

    email
  end

  ##
  # find an email not primary valid
  #
  def self.find_email_forgot (email_s)
    emails = Email.where(email: email_s.downcase)

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

# == Schema Information
#
# Table name: verify_clients
#
#  id         :integer          not null, primary key
#  token      :string
#  data       :string
#  concept    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VerifyClient < ApplicationRecord
  belongs_to :user

  scope :find_verify_client, -> token, concept {
            where('token = ?', token).
            where('concept = ?', concept) unless token.nil? || concept.nil?
          }

  ##
  # Register customer verification and return the token
  #
  def self.token(user_id, email, concept)
    verifyClient = VerifyClient.where('user_id = ?', user_id)
                               .where('concept = ?', concept).take

    verifyClient = VerifyClient.new if verifyClient.nil?

    verifyClient.data = email
    verifyClient.user_id = user_id
    verifyClient.concept = concept
    verifyClient.token = SecureRandom.uuid
    verifyClient.save!

    verifyClient.token
  end
end

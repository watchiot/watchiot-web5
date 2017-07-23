# == Schema Information
#
# Table name: contact_us
#
#  id         :integer          not null, primary key
#  email      :string
#  subject    :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactUs < ApplicationRecord
  validates_presence_of :email, :subject, :body, on: :create
  validates :email, format: { with: /\A[-a-z0-9_+\.]+@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }
end

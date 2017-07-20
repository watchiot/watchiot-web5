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

class ContactU < ApplicationRecord
end

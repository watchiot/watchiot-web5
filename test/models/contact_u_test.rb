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

require 'test_helper'

class ContactUTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

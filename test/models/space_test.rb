# == Schema Information
#
# Table name: spaces
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  user_id       :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class SpaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
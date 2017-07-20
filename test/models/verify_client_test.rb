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

require 'test_helper'

class VerifyClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

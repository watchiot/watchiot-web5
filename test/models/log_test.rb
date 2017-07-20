# == Schema Information
#
# Table name: logs
#
#  id             :integer          not null, primary key
#  description    :text
#  action         :string(20)
#  user_id        :integer
#  user_action_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class LogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

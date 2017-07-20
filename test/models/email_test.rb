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

require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

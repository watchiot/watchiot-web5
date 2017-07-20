# == Schema Information
#
# Table name: faqs
#
#  id       :integer          not null, primary key
#  lang     :string           default("en")
#  question :string
#  answer   :text
#

require 'test_helper'

class FaqTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

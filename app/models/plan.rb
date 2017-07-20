# == Schema Information
#
# Table name: plans
#
#  id               :integer          not null, primary key
#  name             :string
#  amount_per_month :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Plan < ApplicationRecord
end

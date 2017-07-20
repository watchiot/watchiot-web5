# == Schema Information
#
# Table name: plan_features
#
#  id         :integer          not null, primary key
#  plan_id    :integer
#  feature_id :integer
#  value      :string(20)
#

class PlanFeature < ApplicationRecord
end

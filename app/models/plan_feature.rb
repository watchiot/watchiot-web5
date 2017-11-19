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
  belongs_to :plan
  belongs_to :feature

  scope :find_plan_feature, -> plan, feature {
          where('plan_id = ?', plan.id).
          where('feature_id = ?', feature.id).take unless plan.nil? || feature.nil?
        }
end

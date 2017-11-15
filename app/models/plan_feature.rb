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

  scope :find_plan_feature, -> plan_id, feature_id {
          where('plan_id = ?', plan_id).
          where('feature_id = ?', feature_id).take unless plan_id.nil? || feature_id.nil?
        }
end

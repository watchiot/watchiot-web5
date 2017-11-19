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

require 'rails_helper'

RSpec.describe Plan, type: :model do
  before :each do
    before_each 'planModel'
  end

  describe 'valid find plan value' do
    let(:plan) {Plan.find_by_name('Free') }

    it 'is valid find not no exist plan value' do
      value = plan.find_plan_value('dont exist')
      expect(value).to eq(0)
    end

    it 'is valid find plan value team members' do
      value = plan.find_plan_value('Team members')
      expect(value.to_i).to eq(2)
    end

    it 'is valid find plan value notifications by email' do
      value = plan.find_plan_value('Notification by email')
      expect(value).to eq('true')
    end
  end
end

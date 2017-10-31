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

require 'rails_helper'

RSpec.describe Log, type: :model do
  before :each do
    before_each 'logModel'
  end

  describe 'valid save log' do
    it 'is valid save log with big description action' do
      # the action text have to be more short
      expect{ Log.save_log('description', 'this '\
      'description action is to big', @user.id, @user.id) }
          .to raise_error(ActiveRecord::StatementInvalid)
    end

    it 'is valid save log' do
      Log.save_log('description', 'action short', @user.id, @user.id)
      expect(Log.all.count).to eq(1)
    end
  end
end

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

class Log < ApplicationRecord
  belongs_to :user

 ##
 # Save logs by actions
 #
 def self.save_log(description, action, owner_user_id, user_action_id)
   log = Log.new description: description,
                 action: action,
                 user_id: owner_user_id,
                 user_action_id: user_action_id
   log.save
 end
end

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
end

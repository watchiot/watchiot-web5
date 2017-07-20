# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  api_key    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ApiKey < ApplicationRecord
end

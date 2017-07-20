# == Schema Information
#
# Table name: descrips
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  icon        :string
#  lang        :string           default("en")
#

class Descrip < ApplicationRecord
end

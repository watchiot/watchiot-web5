# == Schema Information
#
# Table name: faqs
#
#  id       :integer          not null, primary key
#  lang     :string           default("en")
#  question :string
#  answer   :text
#

class Faq < ApplicationRecord
end

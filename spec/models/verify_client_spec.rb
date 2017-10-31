# == Schema Information
#
# Table name: verify_clients
#
#  id         :integer          not null, primary key
#  token      :string
#  data       :string
#  concept    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe VerifyClient, type: :model do
  before :each do
    before_each 'verifyClientModel'
  end

  describe 'valid verify client' do
    it 'is valid token length' do
      expect(@token.length).to eq(36)
    end

    it 'is valid get verify' do
      verifyClient = VerifyClient.find_by_concept 'verify_client'
      expect(verifyClient.data).to include(@email.email)
    end

    it 'is invalid get verify' do
      verifyClient = VerifyClient.find_by_concept 'concept_not_exist'
      expect(verifyClient).to be_nil
    end
  end
end

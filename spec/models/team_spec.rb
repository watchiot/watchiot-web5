# == Schema Information
#
# Table name: teams
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  user_team_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  before :each do
    before_each 'teamModel'
  end

  describe 'valid add a member' do
    it 'is valid add a new member' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        Team.add_member(@user, 'user1@watchiot.com')
      }.to have_enqueued_job.on_queue('mailers')

      expect(@user.teams.length).to eq(1)
      expect(@user.teams.first.user_team_id)
          .to eq(@user_two.id)
    end

    it 'is valid add a new nil member' do
      expect { Team.add_member(@user, nil) }
          .to raise_error(/The member can not be added/)
    end

    it 'is valid add a new bad email member' do
      expect { Team.add_member(@user, 'bad_emailwatchiot.com') }
          .to raise_error(/The email is not valid/)
    end

    it 'is valid add yourself like member' do
      expect { Team.add_member(@user, 'user@watchiot.com') }
          .to raise_error('The member can not be yourself')
    end

    it 'is valid add the same member' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        Team.add_member(@user, 'user1@watchiot.com')
      }.to have_enqueued_job.on_queue('mailers')

      expect { Team.add_member(@user, 'user1@watchiot.com') }
          .to raise_error('The member was added before')
    end
  end

  describe 'valid add a new member dont register' do
    it 'is valid add a new member dont register' do
      # send two emails for register and added to the team
      ActiveJob::Base.queue_adapter = :test
      expect {
        Team.add_member(@user, 'user_dont_exist@watchiot.com')
      }.to have_enqueued_job.on_queue('mailers').at_least(2)

      username = ('user_dont_exist@watchiot.com'.gsub! /[^0-9a-z\- ]/i, '_')
                     .byteslice 0 , 24
      new_user = User.find_by_username username
      expect(new_user).to be_valid
      # the new account status has to be false
      expect(new_user.status).to eq(false)

      # the email has to be not primary and unchecked
      new_email = Email.find_by_email 'user_dont_exist@watchiot.com'
      expect(new_email).to be_valid
      expect(new_email.primary).to eq(false)
      expect(new_email.checked).to eq(false)

      member = Team.find_member(@user.id, new_user.id).take
      expect(member).to be_valid

      expect(User.all.count).to eq(3)
    end
  end

  describe 'valid add a new member of two accounts' do
    it 'is valid add a new member of two accounts and one of they are primary' do

      api = ApiKey.create(api_key: SecureRandom.uuid)
      plan = Plan.create!(name: 'Free', amount_per_month: 0)

      user_tree = User.create!(username: 'my_user_name2',
                               passwd: '12345678', api_key: api ,plan: plan)
      # not primary email
      email_tree = Email.create!(email: 'user1@watchiot.com',
                                 user_id: user_tree.id)

      ActiveJob::Base.queue_adapter = :test
      expect {
        Team.add_member(@user, 'user1@watchiot.com')
      }.to have_enqueued_job.on_queue('mailers')

      # the account with the primary email was add
      member = Team.find_member(@user.id, @user_two.id).take
      expect(member).to be_valid

      member_two = Team.find_member(@user.id, user_tree.id).take
      expect(member_two).to be_nil
    end

    it 'is valid add a new member in two account and nobody are primary' do
      api = ApiKey.create(api_key: SecureRandom.uuid)
      plan = Plan.create!(name: 'Free', amount_per_month: 0)

      user_tree = User.create!(username: 'my_user_name2',
                               passwd: '12345678', api_key: api, plan: plan)

      email_tree = Email.create!(email: 'user3@watchiot.com',
                                 user_id: user_tree.id)
      api = ApiKey.create(api_key: SecureRandom.uuid)
      user_four = User.create!(username: 'my_user_name3',
                               passwd: '12345678', api_key: api, plan: plan)

      email_four = Email.create!(email: 'user3@watchiot.com',
                                 user_id: user_four.id)
      # the email has to be primary
      expect { Team.add_member(@user, 'user3@watchiot.com') }
          .to raise_error('The member can not be added')
    end
  end

  describe 'valid add members with overflow the plan' do
    it 'is valid add more that 2 members for the free plan' do

      api = ApiKey.create(api_key: SecureRandom.uuid)
      plan = Plan.create!(name: 'Free', amount_per_month: 0)

      user_tree = User.create!(username: 'my_user_name2',
                               passwd: '12345678', api_key: api, plan: plan)
      email_tree = Email.create!(email: 'user2@watchiot.com',
                                 user_id: user_tree.id)

      api = ApiKey.create(api_key: SecureRandom.uuid)
      user_five = User.create!(username: 'my_user_name4',
                               passwd: '12345678', api_key: api, plan: plan)
      email_five = Email.create!(email: 'user4@watchiot.com',
                                 user_id: user_five.id)

      Team.add_member(@user, @email_two.email)
      Team.add_member(@user, email_tree.email)

      # only 3 member of the team in the free plan
      expect {  Team.add_member(@user, email_five.email) }
          .to raise_error('You can not add more members '\
        'to the team, please contact with us!')

    end
  end

  describe 'valid remove a team member' do
    it 'is valid remove a team member' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        Team.add_member(@user, 'user1@watchiot.com')
      }.to have_enqueued_job.on_queue('mailers')

      expect { Team.remove_member(@user, @user_two.id) }
          .to_not raise_error
    end

    it 'is valid remove an invalid team member' do
      expect { Team.remove_member(@user, 2345) }
          .to raise_error('The member is not valid')
    end
  end
end


require 'rails_helper'

##
# This try to test all the space model process
#
RSpec.describe Space, type: :model do
  before :each do
   before_each 'spaceModel'
  end

  describe 'valid namespaces' do
    it 'is valid with a namespace' do
      space = Space.create!(name: 'my_space', user_id: @user.id)
      expect(space.name).to include('my_space')
    end

    it 'is valid nil namespace' do
      space = Space.new(name: nil, user_id: @user.id)
      space.valid?
      expect(space.errors[:name])
          .to include('can\'t be blank')
    end

    it 'is valid with more than 25 characters' do
      space = Space.new(name:'asd aswq ert aaasdasd 324e2 3ewf dfs dfs',
                        user_id: @user.id)
      space.valid?
      expect(space.errors[:name])
          .to include('is too long (maximum is 25 characters)')
    end

    it 'is valid duplicate namespace' do
      space = Space.create!(name: 'my-space', user_id: @user.id)
      expect(space.name).to include('my-space')

      space = Space.new(name:'my space', user_id: @user.id)
      space.valid?
      expect(space.errors[:name])
          .to include('You have a space with this name')

      space = Space.new(name:'My spAce', user_id: @user.id)
      space.valid?
      expect(space.errors[:name])
          .to include('You have a space with this name')

      space = Space.new(name: 'my@space', user_id: @user_two.id)
      space.valid?
      expect(space.name).to include('my_space')
    end

    it 'is valid edit a namespace for duplicate them' do
      params = { name: 'my space',
                 description: 'space description'}
      params1 = { name: 'my space1',
                  description: 'space1 description'}

      space = Space.create_new_space(params, @user, @user)
      expect(space).to be_valid
      space1 = Space.create_new_space(params1, @user, @user)
      expect(space1).to be_valid

      expect { space1.change_space 'my-space' }
          .to raise_error(/You have a space with this name/)
    end
  end

  describe 'valid with more than 2 spaces' do
    it 'is valid with more than 2 spaces with a free plan' do
      params = { name: 'my-space',
                 description: 'space description'}
      params1 = { name: 'space1',
                  description: 'space1 description'}
      params2 = { name: 'space2',
                  description: 'space2 description'}
      params3 = { name: 'space3',
                  description: 'space3 description'}

      space = Space.create_new_space(params, @user, @user)
      expect(space).to be_valid

      params = { name: 'my-space', description: 'space description'}
      expect { Space.create_new_space(params, @user, @user) }
          .to raise_error(/You have a space with this name/)

      params = { name: 'My spAcE',
                           description: 'space description'}
      expect { Space.create_new_space(params, @user, @user) }
          .to raise_error(/You have a space with this name/)

      space1 = Space.create_new_space(params1, @user, @user)
      expect(space1).to be_valid
      expect { Space.create_new_space(params3, @user, @user) }
          .to raise_error('You can not add more spaces, '\
          'please contact with us!')
    end
  end

  describe 'valid format name' do
    it 'is valid a format name with weird characters' do
      namespace = 'aA/*\ @#&)@as'
      space = Space.create!(name: namespace, user_id: @user.id)
      expect(space.name).to include('aa___-_____as')

      namespace = '/*\ @#&)@'
      space = Space.create!(name: namespace, user_id: @user.id)
      expect(space.name).to eq('___-_____')

      namespace = ']@\ @{}]['
      expect { Space.create!(name: namespace, user_id: @user.id) }
          .to raise_error(/You have a space with this name/)
    end
  end

  describe 'valid edit description' do
    it 'is valid edit description space' do
      params = { name: 'my space', description: 'my descrition'}
      space = Space.create_new_space(params, @user, @user)
      expect(space.description).to include('my descrition')

      space.edit_space 'my edit descrition'
      # the name space can not change
      expect(space.name).to include('my-space')
      expect(space.description).to include('my edit descrition')
    end
  end

  describe  'valid delete a space' do
    let(:params) { { name: 'space', description: 'space description'} }
    it 'is valid delete a space without projects' do
      expect(Space.count_spaces @user.id).to eq(0)
      space = Space.create_new_space(params, @user, @user)
      expect(space).to be_valid
      expect(Space.count_spaces @user.id).to eq(1)

      space.delete_space('space')
      expect(Space.count_spaces @user.id).to eq(0)
    end

    it 's valid delete a space with projects' do
      space = Space.create_new_space(params, @user, @user)
      project = Project.create!(name: 'project', space: space, user: @user)

      expect { space.delete_space('space') }
          .to raise_error('This space can not be delete because '\
         'it has one or more projects associate')

      project.destroy!
      space.delete_space('space')
      expect(Space.count_spaces @user.id).to eq(0)
    end
  end

  describe 'valid transfer a space' do
    it 'is valid transfer a space to a not member' do
      params = { name: 'space', description: 'space description'}
      space = Space.create_new_space(params, @user, @user)

      expect { space.transfer(@user, @user_two.id, @email_two) }
          .to raise_error('The member is not valid')
    end

    it 'is valid transfer a space to a member' do
      params = { name: 'space', description: 'space description'}
      space = Space.create_new_space(params, @user, @user)

      Team.add_member(@user, @email_two.email)
      ActiveJob::Base.queue_adapter = :test
      expect {
        space.transfer(@user, @user_two.id, @email_two)
      }.to have_enqueued_job.on_queue('mailers')

      # user do not have space
      expect(Space.count_spaces @user.id).to eq(0)

      # user two have new space
      space = Space.find_by_user_id @user_two.id
      expect(space.name).to eq('space')
    end

    it 'is valid transfer a space with the same space name of the user two' do
      Team.add_member(@user, @email_two.email)

      params = { name: 'space1', description: 'space description'}
      Space.create_new_space(params, @user_two, @user_two)

      # user one add a new space
      params = { name: 'space1', description: 'space description'}
      space = Space.create_new_space(params, @user, @user)

      # we can not transfer a space with the same name
      expect { space.transfer(@user, @user_two.id, @email_two) }
          .to raise_error(/You have a space with this name/)
    end

    it 'is valid transfer a space when the use two has a plan limit' do
      Team.add_member(@user, @email_two.email)
      # add a new space to the user two, it has now 3 space
      params = { name: 'space1', description: 'space description'}
      Space.create_new_space(params, @user_two, @user_two)

      params = { name: 'space2', description: 'space description'}
      Space.create_new_space(params, @user_two, @user_two)

      params = { name: 'space', description: 'space description'}
      space = Space.create_new_space(params, @user, @user)

      expect { space.transfer(@user, @user_two.id, @email_two) }
          .to raise_error('The team member can not add more '\
          'spaces, please contact with us!')
    end
  end
end

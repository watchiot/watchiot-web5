# == Schema Information
#
# Table name: spaces
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  user_id       :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

##
# This try to test all the space model process
#
RSpec.describe Project, type: :model do
  before :each do
   before_each 'projectModel'
  end

  describe 'valid project name' do
    it 'is valid with a namespace' do
      project = Project.create!(name: 'my_project', user_id: @user.id, space_id: @space.id)
      expect(project.name).to include('my_project')
    end

    it 'is valid nil project name' do
      project = Project.new(name: nil, user_id: @user.id, space_id: @space.id)
      project.valid?
      expect(project.errors[:name])
          .to include('can\'t be blank')
    end

    it 'is valid with more than 25 characters' do
      project = Project.new(name:'asd aswq ert aaasdasd 324e2 3ewf dfs dfs',
                        user_id: @user.id, space_id: @space.id)
      project.valid?
      expect(project.errors[:name])
          .to include('is too long (maximum is 25 characters)')
    end

    it 'is valid duplicate proejct name' do
      project = Project.create!(name: 'my-project', user_id: @user.id, space_id: @space.id)
      expect(project.name).to include('my-project')

      project = Project.new(name:'my project', user_id: @user.id, space_id: @space.id)
      project.valid?
      expect(project.errors[:name])
          .to include('You have a project with this name')

      project = Project.new(name:'My prOjecT', user_id: @user.id, space_id: @space.id)
      project.valid?
      expect(project.errors[:name])
          .to include('You have a project with this name')

      project = Project.new(name: 'my@project', user_id: @user_two.id, space_id: @space.id)
      project.valid?
      expect(project.name).to include('my_project')
    end

    it 'is valid edit a name project for duplicate them' do
      params = { name: 'my project',
                 description: 'project description'}
      params1 = { name: 'my project1',
                  description: 'project1 description'}

      project = Project.create_new_project(params, @user_two, @space, @user_two)
      expect(project).to be_valid
      project1 = Project.create_new_project(params1, @user_two, @space, @user_two)
      expect(project1).to be_valid

      expect { project1.change_project 'my-project' }
          .to raise_error(/You have a project with this name/)
    end
  end

  describe 'valid with more than 3 projects' do
    it 'is valid with more than 3 projects with a free plan' do
      params = { name: 'my-project',
                 description: 'project description'}
      params1 = { name: 'project1',
                  description: 'project1 description'}
      params2 = { name: 'project2',
                  description: 'project2 description'}
      params3 = { name: 'project3',
                  description: 'project3 description'}

      project = Project.create_new_project(params, @user, @space, @user)
      expect(project).to be_valid

      params = { name: 'my-project', description: 'project description'}
      expect { Project.create_new_project(params, @user, @space, @user) }
          .to raise_error(/You have a project with this name/)

      params = { name: 'My project',
                           description: 'project description'}
      expect { Project.create_new_project(params, @user, @space, @user) }
          .to raise_error(/You have a project with this name/)

      project1 = Project.create_new_project(params1, @user, @space, @user)
      expect(project1).to be_valid
      project2 = Project.create_new_project(params2, @user, @space, @user)
      expect(project2).to be_valid
      expect { Project.create_new_project(params3, @user, @space, @user) }
          .to raise_error('You can not add more projects, '\
          'please contact with us!')
    end
  end

  describe 'valid format name' do
    it 'is valid a format name with weird characters' do
      name_project = 'aA/*\ @#&)@as'
      project = Project.create!(name: name_project, user_id: @user.id, space_id: @space.id)
      expect(project.name).to include('aa___-_____as')

      name_project = '/*\ @#&)@'
      project = Project.create!(name: name_project, user_id: @user.id, space_id: @space.id)
      expect(project.name).to eq('___-_____')

      name_project = ']@\ @{}]['
      expect { Project.create!(name: name_project, user_id: @user.id, space_id: @space.id) }
          .to raise_error(/You have a project with this name/)
    end
  end

  describe 'valid edit project description and status' do
    it 'is valid edit description project' do
      params = { name: 'my project', description: 'my descrition'}
      project = Project.create_new_project(params, @user, @space, @user)
      expect(project.description).to include('my descrition')

      project.edit_project 'my edit descrition', false
      # the name project can not change
      expect(project.name).to include('my-project')
      expect(project.description).to include('my edit descrition')
      expect(project.status).to eq(false)
    end
  end

  describe  'valid delete a project' do
    let(:params) { { name: 'project', description: 'project description'} }
    it 'is valid delete a project without projects' do
      expect(Project.count_by_user_and_space @user.id, @space.id).to eq(0)
      project = Project.create_new_project(params, @user, @space, @user)
      expect(project).to be_valid
      expect(Project.count_by_user_and_space @user.id, @space.id).to eq(1)

      project.delete_project('project')
      expect(Project.count_by_user_and_space @user.id, @space.id).to eq(0)
    end

    it 's valid delete a project with projects' do
      project = Project.create_new_project(params, @user, @space, @user)

      expect { project.delete_project('project_no name') }
          .to raise_error('The project name is not valid')

      project.delete_project('project')
      expect(Project.count_by_user_and_space @user.id, @space.id).to eq(0)
    end
  end
end

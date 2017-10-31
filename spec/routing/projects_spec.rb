require 'rails_helper'

RSpec.describe 'routes for projects', type: :routing do
  it 'routes all projects' do
    expect(get: '/gorums/my_space/projects').
        to route_to(controller: 'projects',
                    action: 'index',
                    username: 'gorums',
                    namespace: 'my_space')
  end

  it 'routes one project' do
    expect(get: '/gorums/my_space/my_project').
        to route_to(controller: 'projects',
                    action: 'show',
                    username: 'gorums',
                    namespace: 'my_space',
                    nameproject: 'my_project')
  end

  it 'routes create project' do
    expect(post: '/gorums/my_space/create').
        to route_to(controller: 'projects',
                    action: 'create',
                    username: 'gorums',
                    namespace: 'my_space')
  end

  it 'routes edit project' do
    expect(patch: '/gorums/my_space/my_project').
        to route_to(controller: 'projects',
                    action: 'edit',
                    username: 'gorums',
                    namespace: 'my_space',
                    nameproject: 'my_project')
  end

  it 'routes setting project' do
    expect(get: '/gorums/my_space/my_project/setting').
        to route_to(controller: 'projects',
                    action: 'setting',
                    username: 'gorums',
                    namespace: 'my_space',
                    nameproject: 'my_project')
  end

  it 'routes setting change project' do
    expect(patch: '/gorums/my_space/my_project/setting/change').
        to route_to(controller: 'projects',
                    action: 'change',
                    username: 'gorums',
                    namespace: 'my_space',
                    nameproject: 'my_project')
  end

  it 'routes setting delete project' do
    expect(delete: '/gorums/my_space/my_project/setting/delete').
        to route_to(controller: 'projects',
                    action: 'delete',
                    username: 'gorums',
                    namespace: 'my_space',
                    nameproject: 'my_project')
  end

  it 'routes setting evaluate project' do
    expect(patch: '/gorums/my_space/my_project/evaluate').
        to route_to(controller: 'projects',
                    action: 'evaluate',
                    username: 'gorums',
                    namespace: 'my_space',
                    nameproject: 'my_project')
  end

  it 'routes setting deploy project' do
    expect(patch: '/gorums/my_space/my_project/deploy').
        to route_to(controller: 'projects',
                    action: 'deploy',
                    username: 'gorums',
                    namespace: 'my_space',
                    nameproject: 'my_project')
  end
end

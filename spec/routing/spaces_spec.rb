require 'rails_helper'

RSpec.describe 'routes for spaces', type: :routing do
  it 'routes all space' do
    expect(get: '/gorums/spaces').
        to route_to(controller: 'spaces',
                    action: 'index',
                    username: 'gorums')
  end

  it 'routes one space' do
    expect(get: '/gorums/my_space').
        to route_to(controller: 'spaces',
                    action: 'show',
                    username: 'gorums',
                    namespace: 'my_space')
  end

  it 'routes create space' do
    expect(post: '/gorums/create').
        to route_to(controller: 'spaces',
                    action: 'create',
                    username: 'gorums')
  end

  it 'routes edit space' do
    expect(patch: '/gorums/my_space').
        to route_to(controller: 'spaces',
                    action: 'edit',
                    username: 'gorums',
                    namespace: 'my_space')
  end

  it 'routes setting space' do
    expect(get: '/gorums/my_space/setting').
        to route_to(controller: 'spaces',
                    action: 'setting',
                    username: 'gorums',
                    namespace: 'my_space')
  end

  it 'routes setting change space' do
    expect(patch: '/gorums/my_space/setting/change').
        to route_to(controller: 'spaces',
                    action: 'change',
                    username: 'gorums',
                    namespace: 'my_space')
  end

  it 'routes setting transfer space' do
    expect(patch: '/gorums/my_space/setting/transfer').
        to route_to(controller: 'spaces',
                    action: 'transfer',
                    username: 'gorums',
                    namespace: 'my_space')
  end

  it 'routes setting delete space' do
    expect(delete: '/gorums/my_space/setting/delete').
        to route_to(controller: 'spaces',
                    action: 'delete',
                    username: 'gorums',
                    namespace: 'my_space')
  end
end

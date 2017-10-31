require 'rails_helper'

RSpec.describe 'routes for users', type: :routing do
  it 'routes register' do
    expect(get: '/register').
        to route_to(controller: 'users',
                    action: 'register')
  end

  it 'routes do register' do
    expect(post: '/register').
        to route_to(controller: 'users',
                    action: 'do_register')
  end

  it 'routes login' do
    expect(get: '/login').
        to route_to(controller: 'users',
                    action: 'login')
  end

  it 'routes do login' do
    expect(post: '/login').
        to route_to(controller: 'users',
                    action: 'do_login')
  end

  it 'routes do omniauth' do
    expect(get: '/auth/github/callback').
        to route_to(controller: 'users',
                    action: 'do_omniauth',
                    provider: 'github')
  end

  it 'routes logout' do
    expect(get: '/logout').
        to route_to(controller: 'users',
                    action: 'logout')
  end
end

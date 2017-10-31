require 'rails_helper'

RSpec.describe 'routes for generals', type: :routing do
  it 'routes home' do
    expect(get: '/').
        to route_to(controller: 'home',
                    action: 'index')
  end

  it 'routes contact us' do
    expect(post: '/contact').
        to route_to(controller: 'home',
                    action: 'contact')
  end

  it 'routes dashboard' do
    expect(get: '/gorums').
        to route_to(controller: 'dashboard',
                    action: 'show',
                    username: 'gorums')
  end
end

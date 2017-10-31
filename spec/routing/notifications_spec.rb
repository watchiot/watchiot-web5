require 'rails_helper'

RSpec.describe 'routes for notifications', type: :routing do
  it 'routes forgot' do
    expect(get: '/forgot').
        to route_to(controller: 'notifications',
                    action: 'forgot')
  end

  it 'routes do forgot' do
    expect(post: '/forgot').
        to route_to(controller: 'notifications',
                    action: 'forgot_notification')
  end

  it 'routes reset' do
    expect(get: '/reset/12345').
        to route_to(controller: 'notifications',
                    action: 'reset',
                    token: '12345')
  end

  it 'routes do reset' do
    expect(patch: '/reset/12345').
        to route_to(controller: 'notifications',
                    action: 'do_reset',
                    token: '12345')
  end

  it 'routes active' do
    expect(get: '/active/12345').
        to route_to(controller: 'notifications',
                    action: 'active',
                    token: '12345')
  end

  it 'routes verify email' do
    expect(get: '/verify_email/12345').
        to route_to(controller: 'notifications',
                    action: 'verify_email',
                    token: '12345')
  end
  it 'routes invite' do
    expect(get: '/invite/12345').
        to route_to(controller: 'notifications',
                    action: 'invite',
                    token: '12345')
  end
  it 'routes do get' do
    expect(patch: '/invite/12345').
        to route_to(controller: 'notifications',
                    action: 'do_invite',
                    token: '12345')
  end
end

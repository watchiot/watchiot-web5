require 'rails_helper'

RSpec.describe 'routes for setting', type: :routing do

  it 'routes user setting' do
    expect(get: '/gorums/setting').
        to route_to(controller: 'setting',
                    action: 'show',
                    username: 'gorums')
  end

  it 'routes user setting with param' do
    expect(get: '/gorums/setting/param').
        to route_to(controller: 'setting',
                    action: 'show',
                    username: 'gorums', val: 'param')
  end

  it 'bad request' do
    expect(get: '/gorums/setting/param/param2').
        to route_to(controller: 'errors',
                    action: 'routing',
                    a: 'gorums/setting/param/param2')
  end

  it 'routes user setting update profile' do
    expect(patch: '/gorums/setting/profile').
        to route_to(controller: 'setting',
                    action: 'profile',
                    username: 'gorums')
  end

  it 'routes user setting add email' do
    expect(post: '/gorums/setting/account/add/email').
        to route_to(controller: 'setting',
                    action: 'account_add_email',
                    username: 'gorums')
  end

  it 'bad request' do
    expect(post: '/gorums/setting/param/param2').
        to route_to(controller: 'errors', action: 'routing',
                    a: 'gorums/setting/param/param2')
  end

  it 'routes user setting delete email' do
    expect(delete: '/gorums/setting/account/remove/email/1').
        to route_to(controller: 'setting',
                    action: 'account_remove_email',
                    username: 'gorums', id: '1')
  end

  it 'routes user setting set email primary' do
    expect(get: '/gorums/setting/account/primary/email/1').
        to route_to(controller: 'setting',
                    action: 'account_primary_email',
                    username: 'gorums', id: '1')
  end

  it 'routes user setting verify email' do
    expect(get: '/gorums/setting/account/verify/email/1').
        to route_to(controller: 'setting',
                    action: 'account_verify_email',
                    username: 'gorums', id: '1')
  end

  it 'routes user setting change password' do
    expect(patch: '/gorums/setting/account/password').
        to route_to(controller: 'setting',
                    action: 'account_ch_password',
                    username: 'gorums',)
  end

  it 'routes user setting change username' do
    expect(patch: '/gorums/setting/account/username').
        to route_to(controller: 'setting',
                    action: 'account_ch_username',
                    username: 'gorums',)
  end

  it 'routes user setting account delete' do
    expect(delete: '/gorums/setting/account/delete').
        to route_to(controller: 'setting',
                    action: 'account_delete',
                    username: 'gorums',)
  end

  it 'routes user setting add member team' do
    expect(post: '/gorums/setting/team/add').
        to route_to(controller: 'setting',
                    action: 'team_add',
                    username: 'gorums',)
  end

  it 'routes user setting delete member team' do
    expect(delete: '/gorums/setting/team/delete/1').
        to route_to(controller: 'setting',
                    action: 'team_delete',
                    username: 'gorums', id: '1')
  end

  it 'routes user setting key generate' do
    expect(patch: '/gorums/setting/key/generate').
        to route_to(controller: 'setting',
                    action: 'key_generate',
                    username: 'gorums')
  end
end

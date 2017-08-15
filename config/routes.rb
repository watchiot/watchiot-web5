Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/auth/:provider/callback' => 'users#do_omniauth' , as: 'do_omniauth'
  # register route
  post 'register' => 'users#do_register', as: 'do_register'
  # login route
  post 'login' => 'users#do_login', as: 'do_login'
  # logout route
  get 'logout' => 'users#logout', as: 'logout'

  # notifications route
  get 'forgot', controller: 'notifications', action: 'forgot'
  post 'forgot', controller: 'notifications', action: 'forgot_notification'
  get 'reset/:token', controller: 'notifications', action: 'reset'
  patch 'reset/:token', controller: 'notifications', action: 'do_reset'
  get 'active/:token', controller: 'notifications', action: 'active'
  get 'verify_email/:token', controller: 'notifications', action: 'verify_email'
  get 'invite/:token', controller: 'notifications', action: 'invite'
  patch 'invite/:token', controller: 'notifications', action: 'do_invite'

  get 'download' => 'download#index', as: 'download'
  get 'home' => 'home#index', as: 'index'

  get '/:username', controller: 'dashboard', action: 'show'

  # chart route
  get '/:username/chart', controller: 'chart', action: 'show'

  # setting route
  get '/:username/setting(//:val)', controller: 'setting', action: 'show'

  # setting profile route
  patch '/:username/setting/profile', controller: 'setting', action: 'profile'

  # setting account email route
  post '/:username/setting/account/add/email', controller: 'setting', action: 'account_add_email'
  delete '/:username/setting/account/remove/email/:id', controller: 'setting', action: 'account_remove_email'
  get '/:username/setting/account/verify/email/:id', controller: 'setting', action: 'account_verify_email'
  get '/:username/setting/account/primary/email/:id', controller: 'setting', action: 'account_primary_email'

  # setting account route
  patch '/:username/setting/account/password', controller: 'setting', action: 'account_ch_password'
  patch '/:username/setting/account/username', controller: 'setting', action: 'account_ch_username'
  delete '/:username/setting/account/delete', controller: 'setting', action: 'account_delete'

  # setting team route
  post '/:username/setting/team/add', controller: 'setting', action: 'team_add'
  delete '/:username/setting/team/delete/:id', controller: 'setting', action: 'team_delete'

  # setting api route
  patch '/:username/setting/key/generate', controller: 'setting', action: 'key_generate'

  # spaces route
  post '/:username/create', controller: 'spaces', action: 'create'
  get '/:username/spaces', controller: 'spaces', action: 'index'
  patch '/:username/:namespace', controller: 'spaces', action: 'edit'
  get '/:username/:namespace/setting', controller: 'spaces', action: 'setting'
  patch '/:username/:namespace/setting/change', controller: 'spaces', action: 'change'
  delete '/:username/:namespace/setting/delete', controller: 'spaces', action: 'delete'
  patch '/:username/:namespace/setting/transfer', controller: 'spaces', action: 'transfer'
  get '/:username/:namespace', controller: 'spaces', action: 'show'

  # projects route
  get '/:username/:namespace/projects', controller: 'projects', action: 'index'
  post '/:username/:namespace/create', controller: 'projects', action: 'create'

  patch '/:username/:namespace/:nameproject/deploy', controller: 'projects', action: 'deploy'
  patch '/:username/:namespace/:nameproject/evaluate', controller: 'projects', action: 'evaluate'
  get '/:username/:namespace/:nameproject/repo/:reponame', controller: 'projects', action: 'repo'
  get '/:username/:namespace/:nameproject/readme/:reponame', controller: 'projects', action: 'readme'

  # projects setting route

  get '/:username/:namespace/:nameproject/setting', controller: 'projects', action: 'setting'
  patch '/:username/:namespace/:nameproject/setting/change', controller: 'projects', action: 'change'
  delete '/:username/:namespace/:nameproject/setting/delete', controller: 'projects', action: 'delete'

  patch '/:username/:namespace/:nameproject', controller: 'projects', action: 'edit'
  get '/:username/:namespace/:nameproject', controller: 'projects', action: 'show'

  root 'home#index'

  # at the end of you routes.rb
  get '*a', to: 'errors#routing'
  post '*a', to: 'errors#routing'
  patch '*a', to: 'errors#routing'
  delete '*a', to: 'errors#routing'
end

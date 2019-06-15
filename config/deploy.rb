# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"
set :application, 'otamart_vps'
set :repo_url, 'https://github.com/wjhmk/otamart_vps.git'

set :branch, 'master'
set :deploy_to, '/var/www/app/otamart_vps'
set :scm, :git
set :log_level, :debug
set :pty, true

set :bundle_binstubs, nil
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets bundle public/system public/assets}
set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  after :finishing, 'deploy:cleanup'
end

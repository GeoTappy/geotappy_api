# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'geotappy_api'
set :repo_url, 'git@github.com:GeoTappy/geotappy_api.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/apps/geotappy_api'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/newrelic.yml config/settings/production.local.yml config/sidekiq.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system certificates}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# Run db:migrate only if new migrations available
set :conditionally_migrate, true

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Sidekiq
set :sidekiq_config, ->{ File.join(release_path, 'config', 'sidekiq.yml') }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 0 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 0 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end


namespace :rails do
  desc 'Open the rails console on the primary remote server'
  task :console do
    on roles(:app), primary: true do |host|
      command = "/home/#{host.user}/.rbenv/shims/ruby #{deploy_to}/current/bin/rails console #{fetch(:stage)}"
      exec "ssh -l #{host.user} #{host.hostname} -t 'cd #{deploy_to}/current && #{command}'"
    end
  end
end

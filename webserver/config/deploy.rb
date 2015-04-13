# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'frame_by_frame_app'
set :repo_url, 'git@github.com:mjudy94/frame-by-frame.git'
set :repo_tree, 'webserver'
ask :branch, "master"
set :deploy_to, '/var/www/frame_by_frame_app'
set :passenger_restart_command, -> { "passenger-config restart-app #{fetch(:deploy_to)}" }
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :linked_files, %w{config/creds.yml}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
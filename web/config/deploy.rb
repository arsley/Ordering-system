# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]

set :application, 'ordering-dev'
set :repo_url, 'git@github.com:arsley/Ordering-system.git'
set :repo_tree, 'web'
set :deploy_to, '/www/ordering-dev'
set :branch, ENV['BRANCH_NAME'] || 'production'

set :migration_role, :web
set :migration_servers, -> { primary(fetch(:migration_role)) }

set :passenger_restart_with_touch, true
set :passenger_roles, :web

namespace :deploy do
  desc 'Copy environments'
  after :finished, :copy_env do
    on roles(:web) do
      execute "cd #{release_path} && cp .env.sample .env"
    end
  end

  after :copy_env, :'passenger:restart'
end
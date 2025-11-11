# config valid for current version and patch releases of Capistrano
lock "~> 3.19"

set :application, "ptgolf"
# set :repo_url, "developer@stevealex.us:/Users/developer/repo/#{fetch(:application)}.git"
set :repo_url,  "git@github.com:salex/ptgolf7.git"
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :linked_dirs, fetch(:linked_dirs, []).concat(%w{log tmp/pids tmp/cache tmp/sockets vendor/bundle})

set :puma_systemctl_user, :system

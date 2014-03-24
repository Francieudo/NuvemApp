# APP SETTINGS
set :application, "NuvemApp"
set :ip_address , "138.91.116.207"

# GIT SETTINGS
set :scm, :git
set :repository,  "git@github.com:Francieudo/NuvemApp.git"
set :branch, "master"
set :deploy_via, :remote_cache

# SSH SETTINGS
set :user , "francieudo"
set :deploy_to, "var/www/#{application}"
set :shared_directory, "#{deploy_to}/shared"
set :use_sudo, true
set :group_writable, false
default_run_options[:pty] = true

# ROLES
role :app, ip_address
role :web, ip_address
role :db,  "138.91.117.199", :primary => true

# HOOKS
after 'deploy:update_code' do
  db.symlink
  assets.symlink
end

# TASKS
namespace :deploy do
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

namespace :db do
  desc "link database.yml"
  task :symlink do
    run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
  end

  desc "seed database"
  task :seed do
    run "cd #{current_path} && rake db:seed RAILS_ENV=production"
  end
end

namespace :assets do
  desc "symlink paperclip uploads folder"
  task :symlink do
    assets.create_dir
    run <<-CMD
      rm -rf  #{current_path}/public/system &&
      ln -nfs #{shared_path}/system #{release_path}/public/system
    CMD
  end

  desc "create paperclip folder in the shared directory"
  task :create_dir do
    run "test -d #{shared_path}/system || mkdir -p #{shared_path}/system"
  end
end

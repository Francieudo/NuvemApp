set :application, "NuvemApp"
set :ip_address , "138.91.116.207"

set :application, "NuvemApp"
set :user, "francieudo"

set :scm, :git
set :repository, "git@github.com:Francieudo/NuvemApp.git"
set :branch, "master"
set :use_sudo, true

server "138.91.116.207", :web
server "138.91.116.207", :app
server "138.91.116.207", :db, primary: true

set :deploy_to, "var/www/#{application}"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:port] = 22


namespace :deploy do
  desc "Fix permissions"
  task :fix_permissions, :roles => [ :app, :db, :web ] do
    run "chmod +x #{release_path}/config/unicorn_init.sh"
  end

%w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "service unicorn_#{application} #{command}"
    end
  end

task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/apache2.conf /etc/apache2/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    sudo "mkdir -p #{shared_path}/config"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    # Add database config here
  end
  after "deploy:finalize_update", "deploy:fix_permissions"
  after "deploy:finalize_update", "deploy:symlink_config"
end

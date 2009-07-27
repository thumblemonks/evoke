set :application, "evoke"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :repository, "git://github.com/thumblemonks/evoke.git"

set :deploy_to, "/var/app/#{application}"
set :user, "deploy"
set :use_sudo, false
set :runner, nil

role :app, "evoke.thumblemonks.com"
role :web, "evoke.thumblemonks.com"
role :db,  "evoke.thumblemonks.com", :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
    puts "love."
  end
end

namespace :god do
  desc "Terminate the God server to stop the evoke consumer"
  task :terminate do
    run "god terminate"
    puts "love."
  end

  desc "Start the God server with the evoke consumer recipe"
  task :start do
    run "god -c #{current_path}/config/evoke.god"
    puts "love."
  end
end

set :cold_deploy, false
before("deploy:cold") { set :cold_deploy, true }

#
# CONFIG.YML support

task :after_update_code, :roles => :app, :except => {:no_symlink => true} do 
  run <<-CMD 
cd #{release_path} && 
ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml
CMD
end

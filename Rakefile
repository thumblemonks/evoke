require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'boot'

desc 'Default task: run all tests'
task :default => [:test]

task(:set_test_env) { ENV['SINATRA_ENV'] ||= 'test' }

task :environment do
  require './config/boot'
  Thumblemonks::Database.fire_me_up(ENV['SINATRA_ENV'] || 'development')
end

task :test => [:set_test_env, :environment, 'db:migrate']
desc 'Run all tests'
Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc "Open an irb session preloaded with this library"
task :console do
  exec "irb -rubygems -r ./config/boot.rb"
end

namespace :db do
  desc "Migrates the DB"
  task :migrate => :environment do
    Thumblemonks::Database.migrate
  end
end

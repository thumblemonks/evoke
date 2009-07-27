require 'activerecord'
gem 'sqlite3-ruby'

module ThumbleMonks
  module Database
    def self.fire_me_up(env)
      puts "Connecting to #{env} database"
      ActiveRecord::Base.configurations = Configuration["database"]
      ActiveRecord::Base.logger = Logger.new("log/#{env}.log")
      ActiveRecord::Base.establish_connection(env.to_s)
    end
    
    def self.migrate
      puts "Migrating the database"
      ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/../db/migrations")
    end
  end # Database
end # ThumbleMonks

ThumbleMonks::Database.fire_me_up(ENV['APP_ENV'])
ThumbleMonks::Database.migrate

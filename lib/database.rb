require 'activerecord'
gem 'sqlite3-ruby'

module Thumblemonks
  module Database
    # 'test' => {'adapter' => 'sqlite3', 'database' => ':memory:'},
    ConnectionOptions = {
      'test' => {'adapter' => 'sqlite3', 'database' => 'db/test.db'},
      'development' => {'adapter' => "sqlite3", 'database' => "db/development.db"},
      'production' => {'adapter' => "sqlite3", 'database' => "db/production.db"}
    }

    def self.fire_me_up(env='development')
      puts "Connecting to database and migrating"
      ActiveRecord::Base.configurations = ConnectionOptions
      ActiveRecord::Base.logger = Logger.new("log/#{env}.log")
      ActiveRecord::Base.establish_connection(env.to_s)
    end
    
    def self.migrate
      ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/../migrations")
    end
  end # Database
end # Thumblemonks

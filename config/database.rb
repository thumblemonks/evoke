require 'activerecord'
gem 'sqlite3-ruby'

module Thumblemonks
  module Database
    # 'test' => {'adapter' => 'sqlite3', 'database' => ':memory:'},
    # 'production' => {'adapter' => "sqlite3", 'database' => "db/production.db"}
    ConnectionOptions = {
      'test' => {'adapter' => 'sqlite3', 'database' => 'db/test.db'},
      'development' => {'adapter' => 'sqlite3', 'database' => 'db/development.db'},
      'production' => {
        'adapter' => 'mysql', 'database' => 'evoke_production',
        'encoding' => 'utf8', 'timezone' => '+00:00',
        'socket' => '/opt/local/var/run/mysql5/mysqld.sock',
        'username' => 'foo', 'password' => 'bar'
      }
    }

    def self.database_login_filename
      File.dirname(__FILE__) + '/dblogin.yml'
    end

    def self.fire_me_up(env)
      puts "Connecting to database"
      if File.exist?(database_login_filename)
        puts "Loading database login configuration for system [#{env}]"
        login_options = YAML.load_file(database_login_filename)
        ConnectionOptions[env].merge!(login_options[env]) if login_options.has_key?(env)
      end
      ActiveRecord::Base.configurations = ConnectionOptions
      ActiveRecord::Base.logger = Logger.new("log/#{env}.log")
      ActiveRecord::Base.establish_connection(env.to_s)
    end
    
    def self.migrate
      puts "Migrating the database"
      ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/../db/migrations")
    end
  end # Database
end # Thumblemonks

Thumblemonks::Database.fire_me_up(ENV['APP_ENV'])
Thumblemonks::Database.migrate

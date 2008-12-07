God.pid_file_directory = '/var/tmp'

APP_ENV = ENV['APP_ENV'] || 'production'
NAME = 'evoke_consumer'

unless File.exists?('evoke_consumer.rb')
  $stderr.puts "ERROR Exiting"
  $stderr.puts "ERROR Cannot find script ./evoke_consumer.rb"
  exit
end

God.watch do |watcher|
  watcher.name = NAME
  watcher.interval = 15.seconds
  watcher.start = "APP_ENV=#{APP_ENV} ruby #{NAME}.rb"
  watcher.restart = "APP_ENV=#{APP_ENV} ruby #{NAME}.rb"
  watcher.restart_grace = 5.seconds
  watcher.log = "/var/tmp/#{NAME}.log"

  watcher.behavior(:clean_pid_file)

  watcher.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 30.seconds
      c.running = false
    end
  end

  watcher.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minutes
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

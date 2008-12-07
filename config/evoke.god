God.pid_file_directory = '/var/tmp'

NAME = 'evoke_consumer'
# EVOKE_HOME = '/var/app/evoke/current'
EVOKE_HOME = '/Users/justin/code/carerunner/evoke'
APP_ENV = ENV['APP_ENV'] || 'production'

God.watch do |watcher|
  watcher.name = NAME
  watcher.interval = 15.seconds
  watcher.start = "cd #{EVOKE_HOME} && APP_ENV=#{APP_ENV} ruby #{NAME}.rb"
  watcher.restart = "cd #{EVOKE_HOME} && APP_ENV=#{APP_ENV} ruby #{NAME}.rb"
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

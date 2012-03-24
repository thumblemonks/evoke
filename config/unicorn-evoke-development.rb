# unicorn -c config/unicorn-evoke-development.rb -E development
require 'pathname'

ENV['RACK_ENV'] ||= 'development'

# Restart workers that haven't responded in 30 seconds
timeout 30

# 2 workers and 1 master
worker_processes 2

# palindrome!
listen 10101, :tcp_nodelay => true

$stdout.puts "WORKING DIR #{Pathname(__FILE__).dirname.parent.to_s}"
cwd = Pathname(__FILE__).dirname.parent
working_directory cwd.to_s

log_dir = cwd + "log"
log_dir.mkpath
stdout_path (log_dir + "unicorn-stdout.log").to_s
stderr_path (log_dir + "unicorn-stderr.log").to_s

pid_dir = cwd + "tmp" + "pids"
pid_dir.mkpath
pid (pid_dir + "unicorn.pid").to_s


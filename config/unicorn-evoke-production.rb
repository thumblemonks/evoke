# !!! Don't use this file for local testing unless you just really want to
#
# unicorn -c config/unicorn.rb -E production -D

require 'pathname'

ENV['RACK_ENV'] ||= 'production'

# Restart workers that haven't responded in 30 seconds
timeout 30

# 4 workers and 1 master
worker_processes 4

# palindrome!
listen 10101, :tcp_nodelay => true

cwd = Pathname(__FILE__).dirname.parent
working_directory cwd.to_s

log_dir = cwd + "log"
log_dir.mkpath
stdout_path (log_dir + "unicorn-stdout.log").to_s
stderr_path (log_dir + "unicorn-stderr.log").to_s

pid_dir = cwd + "tmp" + "pids"
pid_dir.mkpath
pid (pid_dir + "unicorn.pid").to_s


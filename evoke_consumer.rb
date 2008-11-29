#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'config', 'boot')
Thumblemonks::Database.fire_me_up(:development)

Delayed::Worker.logger = Logger.new("log/development-consumer.log")

Delayed::Worker.new.start

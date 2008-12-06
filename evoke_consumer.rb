#!/usr/bin/env ruby
ENV['APP_ENV'] ||= 'production'
require File.join(File.dirname(__FILE__), 'config', 'boot')

Delayed::Worker.logger = Logger.new("log/development-consumer.log")
Delayed::Worker.new.start

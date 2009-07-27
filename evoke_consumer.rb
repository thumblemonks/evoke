#!/usr/bin/env ruby
ENV['APP_ENV'] ||= ENV['RACK_ENV'] || 'production'
require File.join(File.dirname(__FILE__), 'config', 'boot')

Delayed::Worker.logger = Logger.new("log/#{ENV['APP_ENV']}-consumer.log")
Delayed::Worker.new.start

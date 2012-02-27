#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
$:.unshift(File.join(File.dirname(__FILE__), ".."))
require "rubygems"
require "bundler/setup"
require "mail"
require "ruby-debug"
require "environment"

require 'mail_handler_dispatcher'
Dir.glob(File.join(File.dirname(__FILE__), "..", "lib", "mail_handler", "*"), &method(:require))

message = STDIN.read()

File.open("/tmp/last_acunote_email", "w") do |f|
  f.write(message)
end
MailHandlerDispatcher.handle_mail(message)

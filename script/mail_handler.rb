#!/usr/bin/ruby

$:.unshift("lib")
require "rubygems"
require "bundler/setup"
require "mail"
require "ruby-debug"

require 'mail_handler_dispatcher'
Dir.glob('lib/mail_handler/*', &method(:require))

MailHandlerDispatcher.handle_mail(STDIN.read())


#!/usr/bin/env ruby

app_path = File.dirname(__FILE__)
$:.push(File.join(app_path, 'lib'))

require 'rubygems'
require 'rack'
require 'rack/openid'
require 'rack/request'
require 'omniauth/core'
require 'omniauth/openid'
require 'lib/force_omni_auth_login'
require 'yaml'
require 'irc_web/app'
require 'irc_web/middleware/prepare_user'

# Load our configuration file
CONFIG = YAML.load_file('config.yml')
DataMapper.setup(:default, CONFIG['datamapper'])
Dir.glob(File.join(app_path, 'lib', 'irc_web', 'model/*'), &method(:require))
IrcWeb::User.inspect
DataMapper.finalize()
# DataMapper.auto_migrate!()

# Add environment specific stuff here
# ENV['RACK_ENV'] = :development

use Rack::CommonLogger
use Rack::Reloader
use Rack::ShowExceptions
use Rack::Session::Cookie
use Rack::Static, :urls => ["/media"]
if CONFIG['google_auth_domain']
  use OmniAuth::Builder do
    provider :google_apps, nil, :name => 'login', :domain => CONFIG['google_auth_domain']
  end
  use ForceOmniAuthLogin
end
use IrcWeb::Middleware::PrepareUser

run IrcWeb::App


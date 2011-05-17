#!/usr/bin/env ruby
require 'rubygems'
require 'rack'
require 'rack/openid'
require 'rack/request'
require 'rack/lobster'
require 'omniauth/core'
require 'omniauth/openid'
require 'lib/force_omni_auth_login'
require 'lib/irc_web'
require 'lib/irc_web/config'
require 'yaml'

app_path = File.dirname(__FILE__)
config_path = File.join(app_path, 'config.yml')
yml = YAML::load(
  File.read(config_path)
)
IrcWeb::Config.template_path = yml["template_path"]
IrcWeb::Config.google_auth_domain = yml["google_auth_domain"]

disable :run

use Rack::CommonLogger
use Rack::ShowExceptions
use Rack::Session::Cookie
if IrcWeb::Config.google_auth_domain
  use OmniAuth::Builder do
    provider :google_apps, nil, :name => 'login', :domain => IrcWeb::Config.google_auth_domain
  end
  use ForceOmniAuthLogin
end

run IrcWeb::App


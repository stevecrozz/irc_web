#!/usr/bin/env ruby

app_path = File.dirname(__FILE__)
$:.push(File.join(app_path, 'lib'))

require 'rubygems'
require 'rack'
require 'rack/openid'
require 'rack/request'
require 'rack/multipart'
require 'omniauth/core'
require 'omniauth/openid'
require 'lib/force_omni_auth_login'
require 'yaml'
require 'irc_web/app'
require 'irc_web/middleware/prepare_user'
require 'irc_web/middleware/handle_web_hook'

# Load our configuration file
CONFIG = YAML.load_file('config.yml')
DataMapper.setup(:default, CONFIG['datamapper'])
Dir.glob(File.join(app_path, 'lib', 'irc_web', 'model/*'), &method(:require))
IrcWeb::User.inspect
DataMapper.finalize()
DataMapper.auto_upgrade!()

require 'template_tags/include_tag'
Liquid::Template.register_tag(
  'include', TemplateTags::IncludeTag.path(File.join(app_path, 'includes')))

# Add environment specific stuff here
# ENV['RACK_ENV'] = :development

use Rack::CommonLogger
use Rack::Reloader
use Rack::ShowExceptions
use IrcWeb::Middleware::HandleWebHook
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


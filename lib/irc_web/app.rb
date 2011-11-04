require 'irc_web/config'
require 'irc_web/views'
require 'sinatra/base'
require 'mustache/sinatra'

module IrcWeb

  class App < Sinatra::Base
    register Mustache::Sinatra

    set :mustache, {
      :templates => 'templates',
      :namespace => IrcWeb,
    }

    get '/' do
      @title = "Home"
      mustache :index
    end

  end

end


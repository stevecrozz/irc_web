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
    config = IrcWeb::Config.instance

    get '/' do
      @title = "Home"
      @selected_nav = "home"
      mustache :index
    end

    get '/logs' do
      @title = "Logs"
      @selected_nav = "logs"
      mustache :logs, :locals => {
        :logs => config.irc.logs.raw.keys.sort,
      }
    end

    get '/logs/search' do
      @title = "Logs :: Search"
      @selected_nav = "logs"
      r = Regexp.new(params["q"])
    end

    get '/logs/:filename/download' do |filename|
      if (file = config.irc.logs[filename]) && (File.exists?(file))
        send_file(
          file, :disposition => 'attachment', :filename => File.basename(file)
        )
      else
        raise Sinatra::NotFound
      end
    end

  end

end


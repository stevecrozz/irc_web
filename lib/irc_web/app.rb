require 'sinatra/base'
require 'sinatra/reloader'
require 'liquid'
require 'irc_web/helper'
require 'grep'
require 'data_mapper'

module IrcWeb

  class App < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      liquid :index, {
        :title => "Home",
        :selected_nav => "home",
      }
    end

    get '/logs' do
      liquid :logs, {
        :title => "Logs",
        :selected_nav => "logs",
        :logs => CONFIG['irc']['logs'].keys.sort,
      }
    end

    post '/logs/search' do
      results = Grep.new(
        :cli_options => [
          "--context=5",
          "--max-count=10",
        ]
      ).grep(
        CONFIG['irc']['logs'],
        params["q"]
      )

      liquid :logs_search, {
        :title => "Logs :: Search",
        :selected_nav => "logs",
        :results => results,
      }
    end

    get '/logs/:filename/download' do |filename|
      if (file = CONFIG['irc']['logs'][filename]) && (File.exists?(file))
        send_file(
          file, :disposition => 'attachment', :filename => File.basename(file)
        )
      else
        raise Sinatra::NotFound
      end
    end

    get '/bots' do
    end

    def liquid(template, locals={})
      locals = {
        'username' => request.env['user'].name,
      }.merge(IrcWeb::Helper.global(locals)).
        merge(locals)

      super(template, {:layout => :layout}, locals)
    end

  end

end


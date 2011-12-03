require 'sinatra/base'
require 'sinatra/reloader'
require 'liquid'
require 'irc_web/helper'
require 'irc_web/form/bot'
require 'irc_web/form/web_hook'
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

    bots_new = lambda do
      form = IrcWeb::Form::Bot.new(
        IrcWeb::Bot.new(
          request.params.merge({'updated_by' => request.env['user']})))

      if request.request_method == "POST" && form.save
        redirect '/bots'
      end

      liquid :bots_new, {
        :title => 'Bots :: New',
        :selected_nav => 'bots',
        :form => form,
      }
    end
    get '/bots/new', &bots_new
    post '/bots/new', &bots_new

    get '/bots' do
      bots = IrcWeb::Bot.all()
      liquid :bots_index, {
        :bots => bots.map { |b| b.to_hash },
        :title => 'Bots :: Index',
        :selected_nav => 'bots',
      }
    end

    get '/bots/:id' do
      b = IrcWeb::Bot.get(params[:id])
      liquid :bots_show, {
        :bot => b.to_hash,
        :web_hooks => IrcWeb::WebHook.all(:bot => b).map { |h| h.to_hash },
        :can_edit => b.created_by == request.env['user'],
        :title => 'Bot :: %s' % b.nickname,
        :selected_nav => 'bots',
      }
    end

    bots_edit = lambda do
      b = IrcWeb::Bot.get(params[:id])
      params.delete(:id)
      b.attributes = params
      form = IrcWeb::Form::Bot.new(b, {
        'submit_path' => '/bots/%s/edit' % b.id,
      })

      if request.request_method == "POST" && form.save
        redirect '/bots'
      end

      liquid :bots_new, {
        :title => 'Bots :: Edit',
        :selected_nav => 'bots',
        :form => form,
      }
    end
    get '/bots/:id/edit', &bots_edit
    post '/bots/:id/edit', &bots_edit

    webhooks_new = lambda do
      if params[:bot_id]
        hook = IrcWeb::WebHook.new(
          request.params.merge({
            'updated_by' => request.env['user']}))
        form = IrcWeb::Form::WebHook.new(hook, params)

        if request.request_method == "POST" && form.save
          redirect '/bots/%s' % params[:bot_id]
        end

        liquid :webhooks_new, {
          :form => form,
        }
      else
        raise Sinatra::NotFound
      end
    end
    get '/webhooks/new', &webhooks_new
    post '/webhooks/new', &webhooks_new

    webhooks_edit = lambda do
      hook = IrcWeb::WebHook.get(params[:id])
      params.delete(:id)
      hook.attributes = params
      form = IrcWeb::Form::WebHook.new(hook, {
        'submit_path' => '/webhooks/%s/edit' % hook.id,
      })

      if request.request_method == "POST" && form.save
        redirect '/bots/%s' % params[:bot_id]
      end

      liquid :webhooks_new, {
        :form => form,
        :hook => hook.to_hash,
      }
    end
    get '/webhooks/:id/edit', &webhooks_edit
    post '/webhooks/:id/edit', &webhooks_edit

    def liquid(template, locals={})
      locals = {
        'username' => request.env['user'].name,
      }.merge(IrcWeb::Helper.global(locals)).
        merge(locals)

      super(template, {:layout => :layout}, locals)
    end

  end

end


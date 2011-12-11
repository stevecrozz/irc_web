require 'json'
require 'rbot_remote'

module IrcWeb
  module Middleware
    class HandleWebHook

      def initialize(app)
        @app = app
      end

      def call(env)
        if env['REQUEST_METHOD'] == 'POST' &&
          env['PATH_INFO'] =~ /^\/webhooktokens\/(.*)/

          hook = IrcWeb::WebHook.first(:token => $1)

          if hook.payload_source == 'form_field'
            post = Rack::Utils.parse_query(Rack::Utils.unescape(env['rack.input'].read()))
            if hook.payload_index != ""
              payload = post[hook.payload_index]
            else
              payload = post
            end
          end

          if hook.decode_method == 'json'
            locals = JSON(payload)
          else
            # maybe cgi param decode? maybe not
            locals = payload
          end

          message = Liquid::Template.parse(
            hook.message_template
          ).render(locals)

          broadcast_channels = Liquid::Template.parse(
            hook.broadcast_channels
          ).render(locals).split("\n").reject(&:empty?).map(&:chomp)

          hook.most_recent_request = locals.inspect
          hook.most_recent_message = message
          hook.save()

          bot = hook.bot
          remote = RbotRemote.new(bot.drb_uri, bot.botusername, bot.botpassword)
          remote.say(message, broadcast_channels)

          return [ 200, { 'Content-Type' => 'text/plain' }, [message] ]
        else
          @app.call(env)
        end
      end

    end
  end
end

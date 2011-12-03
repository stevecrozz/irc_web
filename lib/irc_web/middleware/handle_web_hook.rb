require 'json'

module IrcWeb
  module Middleware
    class HandleWebHook

      def initialize(app)
        @app = app
      end

      def call(env)
        if env['REQUEST_METHOD'] == 'POST' &&
          env['REQUEST_PATH'] =~ /^\/webhooktokens\/(.*)/

          hook = IrcWeb::WebHook.first(:token => $1)
          payload = env['rack.input'].read()

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
          ).render(locals).split("\n").reject(:empty?)

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

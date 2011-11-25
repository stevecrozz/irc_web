module IrcWeb
  module Middleware
    class PrepareUser

      def initialize(app)
        @app = app
      end

      def call(env)
        if env['rack.session'] && env['rack.session']['omniauth.auth']
          user_info = env['rack.session']['omniauth.auth']['user_info']
          user = IrcWeb::User.first(
            :email => user_info['email']
          )
          if !user
            user = IrcWeb::User.new({
              :firstname  => user_info['first_name'],
              :lastname   => user_info['last_name'],
              :name       => user_info['name'],
              :email      => user_info['email'],
              :created_at => Time.now,
            })
            user.save
          end
          env['user'] = user
        end
        @app.call(env)
      end

    end
  end
end

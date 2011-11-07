require 'mustache'

module IrcWeb

  module Views

    class Layout < Mustache
      TITLE_PREFIX = "IrcWeb"
      NAV_ITEMS = [
        [ "home", "/" ],
        [ "logs", "/logs" ],
      ]

      def title
        [ TITLE_PREFIX, @title ].compact.join(" :: ")
      end

      def nav
        @selected_nav ||= "home"
        ret = "<ul>"
        NAV_ITEMS.map do |n,u|
          if @selected_nav == n
            ret += "<li><a class=\"selected\" href=\"%s\">%s</a></li>" % [ u, n ]
          else
            ret += "<li><a href=\"%s\">%s</a></li>" % [ u, n ]
          end
        end
        ret += "</ul>"
      end

    end

    class Index < Layout
    end

    class Logs < Layout
    end

  end

end

module IrcWeb
  module Helper
    class Nav < Base

      NAV_ITEMS = [
        [ "home", "/" ],
        [ "logs", "/logs" ],
        [ "bots", "/bots" ],
      ]

      def initialize(options={})
        @selected_nav = options[:selected_nav] || "home"
      end

      def to_liquid
        ret = "<ul>"
        NAV_ITEMS.map do |n,u|
          if @selected_nav == n
            ret += "<li><a class=\"selected\" href=\"%s\">%s</a></li>" % [ u, n ]
          else
            ret += "<li><a href=\"%s\">%s</a></li>" % [ u, n ]
          end
        end
        ret += "</ul>"

        return ret
      end

    end
  end
end

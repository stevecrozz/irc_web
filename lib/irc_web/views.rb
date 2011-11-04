require 'mustache'

module IrcWeb

  module Views

    class Layout < Mustache
      TITLE_PREFIX = "IrcWeb"

      def title
        [ TITLE_PREFIX, @title ].compact.join(" :: ")
      end
    end

    class Index < Layout
    end

  end

end

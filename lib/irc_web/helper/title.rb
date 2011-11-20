module IrcWeb
  module Helper
    class Title < Base

      TITLE_PREFIX = "IrcWeb"

      def initialize(options={})
        @title = options[:title]
      end

      def to_liquid
        [ TITLE_PREFIX, @title ].compact.join(" :: ")
      end

    end
  end
end

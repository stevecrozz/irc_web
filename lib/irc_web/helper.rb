require 'irc_web/helper/base'
require 'irc_web/helper/title'
require 'irc_web/helper/nav'

module IrcWeb

  module Helper

    def self.global(options={})
      {
        :title => IrcWeb::Helper::Title.new(options),
        :nav => IrcWeb::Helper::Nav.new(options),
      }
    end

  end

end

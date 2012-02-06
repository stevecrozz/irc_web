module Rbot
  module Plugins
    class IrcWeb < Plugin

      def bot_say_join_and_part(m, param)
        if @bot.channels.map(&:name).include?(param[:where])
          # If the bot is already in this channel then just send the message

          @bot.say param[:where], param[:what].to_s
        else
          # If the bot is not already there, then join, send the message and then
          # part

          @bot.join(param[:where])
          @bot.say param[:where], param[:what].to_s
          @bot.part(param[:where])
        end
      end

      def help(cmd, topic="")
        case cmd
        when "say_join_and_part"
          _("say_join_and_part <channel> <message> => If already in channel, say <message> to <channel>. Otherwise join <channel>, say <message> to <channel>, then part <channel>.")
        else
          _("%{name}: say_join_and_part") % {:name=>name}
        end
      end

    end
  end
end

irc_web = Rbot::Plugins::IrcWeb.new
irc_web.map 'irc_web'
irc_web.map 'say_join_and_part :where *what',
  :action => 'bot_say_join_and_part',
  :auth_path => 'move'


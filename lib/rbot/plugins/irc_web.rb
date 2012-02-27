module Rbot
  module Plugins
    class IrcWeb < Plugin

      def bot_say_join_and_part(m, param)
        if param[:where].respond_to?(:name)
          where = param[:where].name
        else
          where = param[:where]
        end

        if @bot.channels.map(&:name).include?(where)
          # If the bot is already in this channel then just send the message

          @bot.say where, param[:what].to_s
        else
          # If the bot is not already there, then join, send the message and then
          # part

          @bot.join(where)
          @bot.say where, param[:what].to_s
          @bot.part(where)
        end
      end

      def mail_bridge_subscribe(m, param)
        sub_channel = "subscriptions::by_channel::%s" % m.channel.name
        sub_sub = "subscriptions::by_subscription::%s" % param[:subscription]
        @registry[sub_channel] ||= []
        @registry[sub_sub] ||= []

        if @registry[sub_channel].include?(param[:subscription])
          m.reply "This channel is already subscribed to '#{param[:subscription]}'"
        else
          @registry[sub_channel] = @registry[sub_channel] + [param[:subscription]]
          @registry[sub_sub] = @registry[sub_sub] + [m.channel.name]
          m.reply "This channel is now subscribed to '#{param[:subscription]}'"
        end
        @registry.flush
      end

      def mail_bridge_unsubscribe(m, param)
        sub_channel = "subscriptions::by_channel::%s" % m.channel.name
        sub_sub = "subscriptions::by_subscription::%s" % param[:subscription]
        @registry[sub_channel] ||= []
        @registry[sub_sub] ||= []

        if @registry[sub_channel].include?(param[:subscription])
          @registry[sub_channel] = @registry[sub_channel] - [param[:subscription]]
          @registry[sub_sub] = @registry[sub_sub] - [m.channel.name]
          m.reply "This channel is now unsubscribed from '#{param[:subscription]}'"
        else
          m.reply "This channel isn't subscribed to '#{param[:subscription]}'"
        end
        @registry.flush
      end

      def mail_bridge_publish(m, param)
        sub_sub = "subscriptions::by_subscription::%s" % param[:subscription]
        @registry[sub_sub] ||= []

	@registry[sub_sub].each do |channel|
	  bot_say_join_and_part(m, {
	    :where => channel,
	    :what => param[:message].to_s,
	  })
	end
      end

      def mail_bridge_list(m, param)
        sub_channel = "subscriptions::by_channel::%s" % m.channel.name
        @registry[sub_channel] ||= []

        if @registry[sub_channel].count > 0
          subscriptions = @registry[sub_channel].join(", ")
          m.reply "This channel is subscribed to: %s" % subscriptions
        else
          m.reply "This channel has no subscriptions"
        end
      end

      def help(cmd, topic="")
        case cmd
        when "say_join_and_part"
          _("say_join_and_part <channel> <message> => If already in channel, say <message> to <channel>. Otherwise join <channel>, say <message> to <channel>, then part <channel>.")
        when "mail_bridge"
          _("commands are: subscribe, unsubscribe, list")
        when "mail_bridge subscribe"
          _("mail_bridge subscribe to <subscription> => Subscribe this channel to mail bridge subscription.")
        when "mail_bridge unsubscribe"
          _("mail_bridge unsubscribe from <subscription> => Unsubscribe this channel from a mail bridge subscription.")
        when "mail_bridge list"
          _("mail_bridge list => List all of this channel's subscriptions.")
        else
          _("%{name}: say_join_and_part, mail_bridge") % {:name=>name}
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
irc_web.map 'mail_bridge subscribe to :subscription',
  :action => 'mail_bridge_subscribe'
irc_web.map 'mail_bridge unsubscribe from :subscription',
  :action => 'mail_bridge_unsubscribe'
irc_web.map 'mail_bridge publish :subscription *message',
  :action => 'mail_bridge_publish'
irc_web.map 'mail_bridge list',
  :action => 'mail_bridge_list'


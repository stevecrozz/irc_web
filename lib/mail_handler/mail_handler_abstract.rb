require 'rbot/rbot_remote'
require 'data_mapper'
require 'environment'
require 'irc_web/model/bot'

class MailHandlerAbstract
  def self.should_handle?(message)
    raise "MailHandlerAbstract cannot handle anything!"
  end

  def self.handle(message)
    raise "MailHandlerAbstract cannot handle anything!"
  end

  def self.publish(subscription, message)
    IrcWeb::Bot.all.each do |bot|
      if !bot.drb_uri.empty?
        remote ||= Rbot::RbotRemote.new(bot.drb_uri, bot.botusername, bot.botpassword)
        remote.publish(subscription, message)
      end
    end
  end
end


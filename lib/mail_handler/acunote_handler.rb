require 'mail_handler/mail_handler_abstract'

class AcunoteHandler < MailHandlerAbstract

  LIST_ID_REGEX = /^List-Id: Acunote Notifications/
  SPRINT_ID_REGEX = /^https:\/\/[^\.]+\.acunote.com\/tasks\/goto\/s(\d+)#/

  def self.should_handle?(message)
    if message.to_s =~ LIST_ID_REGEX
      return true
    end
  end

  def self.handle(message)
    # This message is actually in the body
    if !message.subject
      message = Mail.read_from_string(message.body)
    end

    message.to_s =~ SPRINT_ID_REGEX
    sprint_id = $1
    topic = message.subject
    action = message.body.to_s.lines.first

    subscription = "acunote/sprints/%s" % sprint_id
    irc_message = "%s :: %s" % [topic, action]

    puts subscription
    puts irc_message

    publish(subscription, irc_message)
  end
end

MailHandlerDispatcher.register_handler(AcunoteHandler)

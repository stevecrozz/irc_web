class MailHandlerDispatcher
  @@handlers = []

  def self.handle_mail(str)
    message = Mail.read_from_string(str)
    @@handlers.each do |handler|
      if handler.should_handle?(message)
        return handler.handle(message)
      end
    end
  end

  def self.register_handler(handler_class)
    @@handlers.push(handler_class)
  end
end

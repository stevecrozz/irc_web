class MailHandlerAbstract
  def self.should_handle?(message)
    raise "MailHandlerAbstract cannot handle anything!"
  end

  def self.handle(message)
    raise "MailHandlerAbstract cannot handle anything!"
  end
end

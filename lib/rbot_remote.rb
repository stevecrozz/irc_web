require 'drb'

class RbotRemote

  def self.quick_exec
    uri = 'druby://localhost:7268'
    rbot = DrbObject.new_with_uri(uri)
    id = rbot.delegate(nil, "remote login %s %s" % user, pass)[:return]
    rbot.delegate(id, "dispatch ")
  end

end

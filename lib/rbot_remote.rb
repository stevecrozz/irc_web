require 'drb'
require 'drb/ssl'

class RbotRemote

  def initialize(uri, user, pass)
    @drb_client = DrbObject.new_with_uri(uri)
    @id = @drb_client.delegate(nil, "remote login %s %s" % user, pass)[:return]
  end

  def say(thing, channels)
    Array(channels).each do |channel|
      @drb_client.delegate(@id, "dispatch say %s %s" % [thing, channel])
    end
  end

end

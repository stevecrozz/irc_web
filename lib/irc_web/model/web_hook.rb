module IrcWeb

  class WebHook
    include DataMapper::Resource

    belongs_to :created_by, 'IrcWeb::User'
    belongs_to :updated_by, 'IrcWeb::User'
    belongs_to :bot, 'IrcWeb::Bot'

    property :id, Serial
    property :token, String
    property :payload_source, String
    property :payload_index, String
    property :decode_method, String
    property :message_template, Text
    property :broadcast_channels, Text
    property :most_recent_request, Text
    property :most_recent_message, Text
    property :created_at, DateTime
    property :updated_at, DateTime

    def save
      if !self.token
        self.token = rand(36**50).to_s(36)
      end
      super
    end

    def to_hash
      {
        'id' => self.id,
        'token' => self.token,
        'decode_method' => self.decode_method,
        'message_template' => self.message_template,
        'broadcast_channels' => self.broadcast_channels,
        'most_recent_request' => self.most_recent_request,
        'most_recent_message' => self.most_recent_message,
      }
    end

  end

end

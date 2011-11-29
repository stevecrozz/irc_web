module IrcWeb

  class WebHook
    include DataMapper::Resource

    belongs_to :created_by, 'IrcWeb::User'
    belongs_to :updated_by, 'IrcWeb::User'
    belongs_to :bot, 'IrcWeb::Bot'

    property :id, Serial
    property :token, String
    property :decode_method, String
    property :message_template, Text
    property :broadcast_channels, String
    property :most_recent_message, Text
    property :created_at, DateTime
    property :updated_at, DateTime

  end

end

module IrcWeb

  class Bot
    include DataMapper::Resource

    belongs_to :created_by, 'IrcWeb::User'
    belongs_to :updated_by, 'IrcWeb::User'

    property :id, Serial
    property :nickname, String
    property :password, String
    property :created_at, DateTime
    property :updated_at, DateTime

    def to_liquid
      self.nickname
    end

  end

end

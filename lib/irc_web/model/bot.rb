require 'digest'

module IrcWeb

  class Bot
    include DataMapper::Resource

    belongs_to :created_by, 'IrcWeb::User'
    belongs_to :updated_by, 'IrcWeb::User'

    property :id, Serial
    property :nickname, String
    property :password, String
    property :sha256password, String, :length => 64
    property :type, String
    property :botusername, String
    property :botpassword, String
    property :created_at, DateTime
    property :updated_at, DateTime

    def save
      self.sha256password = Digest::SHA256.hexdigest(self.password.to_s)
      super
    end

    def to_hash
      {
        'id' => self.id,
        'nickname' => self.nickname,
        'password' => self.password,
        'type' => self.type,
        'botusername' => self.botusername,
        'botpassword' => self.botpassword,
      }
    end

    def to_liquid
      self.nickname
    end

  end

end

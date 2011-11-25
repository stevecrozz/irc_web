module IrcWeb

  class Bot
    include DataMapper::Resource

    belongs_to :user

    property :id, Serial
    property :nickname, String
    property :password, String
    property :created_by, Integer
    property :created_at, DateTime
    property :updated_by, Integer
    property :updated_at, DateTime
  end

end

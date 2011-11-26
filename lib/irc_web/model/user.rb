module IrcWeb

  class User
    include DataMapper::Resource

    property :id, Serial
    property :email, String
    property :name, String
    property :firstname, String
    property :lastname, String
    property :created_at, DateTime
  end

end

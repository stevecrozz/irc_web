module IrcWeb

  module Config

    @@google_auth_domain = nil

    def self.google_auth_domain=(domain)
      @@google_auth_domain = domain
    end

    def self.google_auth_domain()
      @@google_auth_domain
    end

  end

end

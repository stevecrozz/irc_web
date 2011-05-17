module IrcWeb

  module Config

    @@template_path = nil
    @@google_auth_domain = nil

    def self.template_path=(path)
      @@template_path = path
    end

    def self.template_path()
      @@template_path
    end

    def self.google_auth_domain=(domain)
      @@google_auth_domain = domain
    end

    def self.google_auth_domain()
      @@google_auth_domain
    end

  end

end

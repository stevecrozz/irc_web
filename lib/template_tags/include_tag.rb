require 'liquid'

module TemplateTags
  class IncludeTag < Liquid::Tag
    def self.path(path)
      @@path = path
      self
    end

    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      path_to_file = File.join(@@path, "%s.html" % @name.strip())

      begin
        file = File.open(path_to_file)
        return file.read()
      rescue Errno::ENOENT => e
        return ""
      end
    end
  end
end

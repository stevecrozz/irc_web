require 'web_form/field/abstract'
require 'web_form/field/text'

module WebForm
  class Base

    attr_accessor :action
    attr_accessor :http_method
    attr_accessor :submit_value

    def self.field(name, klass)
      if !@form_name
        self.name =~ /([^:.]*)$/
        @form_name = $1.downcase
      end
      @fields      ||= []
      @field_names ||= []

      # Create the field
      field = klass.new(name, @form_name)

      if index = @field_names.index(name)
        # We had this one before, overwrite it
        @fields[index] = field
      else
        # Brand spankin new field, push it
        @fields.push(field)
        @field_names.push(name)
      end
    end

    def self.fields
      @fields
    end

    def initialize(options={})
      @action ||= options.delete('action')
      @http_method ||= options.delete('http_method') || 'post'
      @submit_value ||= "Submit"
    end

    def valid?
    end

    def to_s

    end

    def fields
      self.class.fields
    end

    def to_liquid
      ret  = "<form method=\"%s\" action=\"%s\">" % [http_method, action]
      ret += "<ol>"
      fields.each do |field|
        ret += "<li>" + field.label + field.to_s + "</li>"
      end
      ret += "<li class=\"actions\">"
      ret += "<input type=\"submit\" value=\"%s\"></input>" % submit_value
      ret += "</li>"
      ret += "</ol>"
      ret += "</form>"
      return ret
    end
  end
end

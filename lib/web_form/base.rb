require 'web_form/field/abstract'
require 'web_form/field/hidden'
require 'web_form/field/select'
require 'web_form/field/text'
require 'web_form/field/text_area'

module WebForm
  class Base

    attr_accessor :action
    attr_accessor :http_method
    attr_accessor :submit_value

    def self.field(name, klass, options={})
      if !@form_name
        self.name =~ /([^:.]*)$/
        @form_name = $1.downcase
      end
      @fieldsets    ||= {}
      @fields       ||= []
      @field_names  ||= []
      @field_lookup ||= {}

      # Create the field
      field = klass.new(name, @form_name, options)
      if field.fieldset
        @fieldsets[field.fieldset] ||= []
        if !@fieldsets[field.fieldset].include?(field.name)
          @fieldsets[field.fieldset].push(field.name)
        end
      end

      if index = @field_names.index(name)
        # We had this one before, overwrite it
        @fields[index] = field
      else
        # Brand spankin new field, push it
        @field_lookup[name] = @fields.length
        @fields.push(field)
        @field_names.push(name)
      end
    end

    def self.fields
      @fields
    end

    def self.fieldsets
      @fieldsets
    end

    def self.field_lookup
      @field_lookup
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
      fields_handled = []
      ret  = "<form method=\"%s\" action=\"%s\">" % [http_method, action]
      hidden_fields = ""
      ret += "<ol>"
      fields.each do |field|

        if fields_handled.include?(field.name)
          next
        end

        if field.fieldset
          ret += "<li>"
          ret += "<fieldset>"
          ret += "<legend>"
          ret += field.fieldset.to_s
          ret += "</legend>"
          ret += "<ol>"
          self.class.fieldsets[field.fieldset].each do |name|
            field = fields[self.class.field_lookup[name]]
            ret += "<li>" + field.label + field.to_s + "</li>"
            fields_handled.push(field.name)
          end
          ret += "</ol>"
          ret += "</fieldset>"
          ret += "</li>"
          next
        end

        if field.hidden?
          hidden_fields += field.to_s
        else
          ret += "<li>" + field.label + field.to_s + "</li>"
        end

        fields_handled.push(field.name)

      end

      ret += "<li class=\"actions\">"
      ret += "<input type=\"submit\" value=\"%s\"></input>" % submit_value
      ret += "</li>"
      ret += "</ol>"
      ret += hidden_fields
      ret += "</form>"
      return ret
    end
  end
end

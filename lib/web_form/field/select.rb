module WebForm
  module Field
    class Select < Abstract
      attr_accessor :options

      def initialize(field_name, form_name, options={})
        if options[:options]
          @options = options[:options]
        end

        super(field_name, form_name, options)
      end

      def to_s
        ret = "<select id=\"%s\" name=\"%s\">" % [@id, @name]
        options && options.each do |k,v|
          if value == v
            ret += "<option selected=\"selected\" value=\"%s\">%s</option>" % [v,k]
          else
            ret += "<option value=\"%s\">%s</option>" % [v,k]
          end
        end
        ret += "</select>"
      end
    end
  end
end

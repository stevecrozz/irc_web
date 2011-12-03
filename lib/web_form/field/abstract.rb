module WebForm
  module Field
    class Abstract
      attr_accessor :name
      attr_accessor :form
      attr_accessor :fieldset

      def initialize(field_name, form_name, options={})
        @id = "%s_%s" % [form_name, field_name]
        @name = field_name
        @fieldset = options.delete(:fieldset)
      end

      def value=(value)
        @value = value
      end

      def value
        @value
      end

      def label
        "<label for=\"%s\">%s</label>" % [@id, @name]
      end

      def hidden?
        false
      end
    end
  end
end


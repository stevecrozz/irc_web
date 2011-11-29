module WebForm
  module Field
    class TextArea < Abstract
      def to_s
        "<textarea id=\"%s\" name=\"%s\">" % [@id, @name] +
        @value.to_s +
        "</textarea>"
      end
    end
  end
end

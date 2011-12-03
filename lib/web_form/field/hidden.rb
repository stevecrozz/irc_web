module WebForm
  module Field
    class Hidden < Abstract
      def to_s
        (
          "<input id=\"%s\" type=\"hidden\" name=\"%s\" value=\"%s\">" % [@id, @name, @value] +
          "</input>"
        )
      end

      def hidden?
        true
      end
    end
  end
end

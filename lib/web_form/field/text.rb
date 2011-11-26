module WebForm
  module Field
    class Text < Abstract
      def to_s
        "<input id=\"%s\" type=\"text\" name=\"%s\" value=\"%s\">" % [@id, @name, @value]
      end
    end
  end
end

require 'web_form/base'

module IrcWeb
  module Form
    class Bot < WebForm::Base

      SUBMIT_PATH = '/bots/new'

      field :nickname, WebForm::Field::Text
      field :password, WebForm::Field::Text

      def initialize(object=nil, options={})
        @action = SUBMIT_PATH
        @submit_value = "Create Bot"

        if @object = object
          @object.updated_at = Time.now

          if @object.new?
            @object.created_at = @object.updated_at
            @object.created_by = @object.updated_by
          else
            @submit_value = "Update Bot"
          end

          @data = @object.attributes
        end
        super(options)

        self.class.fields.each do |field|
          field.value = self.attributes[field.name]
        end
      end

      def method_missing(sym, *args, &block)
        @object.send(sym, *args, &block)
      end

    end
  end
end

require 'web_form/base'

module IrcWeb
  module Form
    class WebHook < WebForm::Base

      SUBMIT_PATH = '/webhooks/new'

      field :decode_method, WebForm::Field::Select, :options => {
        "none" => "none",
        "json" => "json",
      }
      field :message_template, WebForm::Field::TextArea
      field :broadcast_channels, WebForm::Field::TextArea

      def initialize(object=nil, options={})
        @action = SUBMIT_PATH
        @submit_value = "Create Web Hook"

        if @object = object
          @object.updated_at = Time.now

          if @object.new?
            @object.created_at = @object.updated_at
            @object.created_by = @object.updated_by
          else
            @submit_value = "Update Web Hook"
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

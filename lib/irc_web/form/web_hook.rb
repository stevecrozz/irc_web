require 'web_form/base'

module IrcWeb
  module Form
    class WebHook < WebForm::Base

      DEFAULT_SUBMIT_PATH = '/webhooks/new'

      field :bot_id, WebForm::Field::Hidden
      field :payload_source, WebForm::Field::Select, :options => {
        "form field"   => "form_field",
        "request body" => "request_body",
      }
      field :payload_index, WebForm::Field::Text
      field :decode_method, WebForm::Field::Select, :options => {
        "json" => "json",
      }
      field :message_template, WebForm::Field::TextArea
      field :broadcast_channels, WebForm::Field::TextArea

      def initialize(object=nil, options={})
        @action = options['submit_path'] || DEFAULT_SUBMIT_PATH
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

require 'web_form/base'

module IrcWeb
  module Form
    class Bot < WebForm::Base

      DEFAULT_SUBMIT_PATH = '/bots/new'

      field :nickname, WebForm::Field::Text, :fieldset => :network_settings
      field :password, WebForm::Field::Text, :fieldset => :network_settings

      field :type, WebForm::Field::Select, :options => {
        "rbot" => "rbot",
      }, :fieldset => :bot_settings
      field :drb_uri, WebForm::Field::Text, :fieldset => :bot_settings
      field :botusername, WebForm::Field::Text, :fieldset => :bot_settings
      field :botpassword, WebForm::Field::Text, :fieldset => :bot_settings

      def initialize(object=nil, options={})
        @action = options['submit_path'] || DEFAULT_SUBMIT_PATH
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

require 'sinatra'
require 'liquid'

module IrcWeb

  class App < Sinatra::Base

    TEMPLATE_PATH = 'templates'

    get '/' do
      render :index
    end

    private

    def render(path, locals={})
      Liquid::Template.parse(
        File.read(
          File.join(IrcWeb::Config.template_path, "%s.liquid" % path.to_s)
        )
      ).render(locals)
    end

  end

end

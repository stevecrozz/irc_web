require 'data_mapper'

app_path = File.join(File.dirname(__FILE__))
CONFIG = YAML.load_file(File.join(app_path, 'config.yml'))
DataMapper.setup(:default, CONFIG['datamapper'])
Dir.glob(File.join(app_path, 'lib', 'irc_web', 'model/*'), &method(:require))
IrcWeb::User.inspect
DataMapper.finalize()
DataMapper.auto_upgrade!()

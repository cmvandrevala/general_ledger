$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'db/database_connection'

DB = DatabaseConnection.new.create

get '/' do
  'Hello World!'
end

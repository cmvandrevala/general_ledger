$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sequel'
require_relative '../../db/database_connection'

db = DatabaseConnection.new.create

class Institution < Sequel::Model(db[:institutions])
  one_to_many :accounts
end

Institution.plugin :timestamps, update_on_create: true

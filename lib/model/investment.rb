$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sequel'
require_relative '../../db/database_connection'

db = DatabaseConnection.new.create

class Investment < Sequel::Model(db[:investments])
  many_to_one :account
  one_to_many :snapshots
end

Investment.plugin :timestamps, update_on_create: true

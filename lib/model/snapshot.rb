$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sequel'
require_relative '../../db/database_connection'

db = DatabaseConnection.new.create

class Snapshot < Sequel::Model(db[:snapshots])
  many_to_one :investment
end

Snapshot.plugin :timestamps, update_on_create: true

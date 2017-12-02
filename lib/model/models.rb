$LOAD_PATH.unshift(File.dirname(__FILE__))

require "sequel"
require_relative '../../db/database_connection'

DB = DatabaseConnection.new.create

class Institution < Sequel::Model(DB[:institutions]); end
class Account < Sequel::Model(DB[:accounts]); end
class Snapshot < Sequel::Model(DB[:snapshots]); end

Institution.plugin :timestamps, update_on_create: true
Account.plugin :timestamps, update_on_create: true
Snapshot.plugin :timestamps, update_on_create: true

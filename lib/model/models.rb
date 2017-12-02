$LOAD_PATH.unshift(File.dirname(__FILE__))

require "sequel"
require_relative '../../db/database_connection'

DB = DatabaseConnection.new.create

class Institution < Sequel::Model(DB[:institutions]);
  one_to_many :accounts
end

class Account < Sequel::Model(DB[:accounts]);
  many_to_one :institution
  one_to_many :snapshots
end

class Snapshot < Sequel::Model(DB[:snapshots]);
  many_to_one :account
end

Institution.plugin :timestamps, update_on_create: true
Account.plugin :timestamps, update_on_create: true
Snapshot.plugin :timestamps, update_on_create: true

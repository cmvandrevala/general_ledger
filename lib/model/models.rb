$LOAD_PATH.unshift(File.dirname(__FILE__))

require "sequel"
require_relative '../../db/database_connection'

DB = DatabaseConnection.new.create

class Institution < Sequel::Model(DB[:institutions]);
  one_to_many :accounts
end

class Account < Sequel::Model(DB[:accounts]);
  many_to_one :institution
  one_to_many :investments

  def self.find_from_json(json)
    institution = Institution.where(name: json["institution"]).first
    Account.where(name: json["name"], owner: json["owner"], institution_id: institution[:id]).first
  end
end

class Investment < Sequel::Model(DB[:investments]);
  many_to_one :account
  one_to_many :snapshots
end

class Snapshot < Sequel::Model(DB[:snapshots]);
  many_to_one :investment
end

Institution.plugin :timestamps, update_on_create: true
Account.plugin :timestamps, update_on_create: true
Investment.plugin :timestamps, update_on_create: true
Snapshot.plugin :timestamps, update_on_create: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sequel'
require_relative '../../db/database_connection'
require_relative './institution'

db = DatabaseConnection.new.create

class Account < Sequel::Model(db[:accounts])
  many_to_one :institution
  one_to_many :investments

  def self.find_from_json(json)
    institution = Institution.where(name: json['institution']).first
    if !institution.nil?
      Account.where(name: json['account'], owner: json['owner'], institution_id: institution[:id]).first
    end
  end
end

Account.plugin :timestamps, update_on_create: true

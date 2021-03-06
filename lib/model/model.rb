require 'sequel'
require 'yaml'

environment = ENV['ENV']

if File.file? 'config.yml'
  database_config = YAML.load_file('config.yml')
else
  database_config = {"test"=>[{"adapter"=>"postgres", "database"=>"test_ledger", "encoding"=>"utf8", "host"=>"localhost", "pool"=>5, "user"=>"postgres"}]}
end

params = database_config[environment].reduce({}, :merge)
db = Sequel.connect(params)

class Institution < Sequel::Model(db[:institutions])
  one_to_many :accounts
end

class Account < Sequel::Model(db[:accounts])
  many_to_one :institution
  one_to_many :investments
end

class Investment < Sequel::Model(db[:investments])
  many_to_one :account
  one_to_many :snapshots
end

class Snapshot < Sequel::Model(db[:snapshots])
  many_to_one :investment
end

Institution.plugin :timestamps, update_on_create: true
Account.plugin :timestamps, update_on_create: true
Investment.plugin :timestamps, update_on_create: true
Snapshot.plugin :timestamps, update_on_create: true

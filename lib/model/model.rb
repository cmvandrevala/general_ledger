require 'sequel'
require 'yaml'

environment = 'test'
database_config = YAML.load_file('config.yml')
params = database_config[environment].reduce({}, :merge)
db = Sequel.connect(params)

class Account < Sequel::Model(db[:accounts])
  many_to_one :institution
  one_to_many :investments
end

class Institution < Sequel::Model(db[:institutions])
  one_to_many :accounts
end

class Investment < Sequel::Model(db[:investments])
  many_to_one :account
  one_to_many :snapshots
end

class Snapshot < Sequel::Model(db[:snapshots])
  many_to_one :investment
end

Account.plugin :timestamps, update_on_create: true
Institution.plugin :timestamps, update_on_create: true
Investment.plugin :timestamps, update_on_create: true
Snapshot.plugin :timestamps, update_on_create: true

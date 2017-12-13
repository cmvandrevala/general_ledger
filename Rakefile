require 'sequel'
require 'yaml'

task :default => [:start]

desc 'Start the server containing the general ledger data'
task :start do
  exec('rackup -s thin -p 4567')
end

namespace :db do
  Sequel.extension :migration
  migrations_directory = 'db/migrations'

  environment = 'test'
  database_config = YAML.load_file('config.yml')
  params = database_config[environment].reduce({}, :merge)
  DB = Sequel.connect(params)

  desc 'Prints the current schema version'
  task :version do
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0
    puts "Schema Version: #{version}"
  end

  desc 'Perform migrations up to latest migration available'
  task :migrate do
    Sequel::Migrator.run(DB, migrations_directory)
    Rake::Task['db:version'].execute
  end

  desc 'Perform rollback to specified target or full rollback as default'
  task :rollback, :target do |_, args|
    args.with_defaults(:target => 0)
    Sequel::Migrator.run(DB, migrations_directory, :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc 'Perform migration reset (full rollback and migration)'
  task :reset do
    Sequel::Migrator.run(DB, migrations_directory, :target => 0)
    Sequel::Migrator.run(DB, migrations_directory)
    Rake::Task['db:version'].execute
  end
end

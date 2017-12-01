$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'db/database_connection'

task :default => [:start]

desc 'Start the Server to Serve General Ledger Data'
task :start do
  ruby 'main.rb'
end

namespace :db do
  Sequel.extension :migration
  migrations_directory = 'db/migrations'
  DB = DatabaseConnection.new.create

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

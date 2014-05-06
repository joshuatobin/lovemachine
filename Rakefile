require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/*_test.rb', 'spec/*_spec.rb']
  t.verbose = true
end

desc "Create db for first time setup"
task :create_db do 
  sh 'createdb lovemachine'
  sh 'sequel -m migrations postgres:///lovemachine'
end

desc "Drop and recreate lovemachine-test database"
task :create_test_db => [:drop_test_db] do
  sh 'createdb lovemachine-test'
  sh 'sequel -m migrations postgres:///lovemachine-test'
end

desc "Drop the lovemachine-test database"
task :drop_test_db do
  sh 'dropdb lovemachine-test || true'
end

task all: [:create_test_db, :test]

namespace :db do
  require "sequel"
  Sequel.extension :migration
  db = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/lovemachine')
  
  desc "Prints current schema version"
  task :version do    
    version = if db.tables.include?(:schema_info)
      db[:schema_info].first[:version]
    end || 0
 
    puts "Schema Version: #{version}"
  end
 
  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(db, "migrations")
    Rake::Task['db:version'].execute
  end
    
  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)
 
    Sequel::Migrator.run(db, "migrations", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end
 
  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(db, "migrations", :target => 0)
    Sequel::Migrator.run(db, "migrations")
    Rake::Task['db:version'].execute
  end    
end

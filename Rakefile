require "rake/testtask"

require_relative "config/initializers/sequel"
require_relative "lib/rake/tasks/refresh_routers"

Rake::TestTask.new do |t|
  t.pattern = "spec/[^integration]*/*_spec.rb"
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.name    = "test:all"
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.name    = "test:integration"
  t.pattern = "spec/integration/**/*_spec.rb"
  t.verbose = true
end

namespace :db do
  Sequel.extension(:migration)
  migrations_dir = "db/migrations"

  desc 'Run any pending migrations - e.g. rake "db:migrate[201306261051]"'
  task :migrate, :migration do |t, args|
    target_migration = args[:migration] ? args[:migration].to_i : nil
    Sequel::Migrator.apply(DB, migrations_dir, target_migration)
  end

  desc "Rollback all database migrations"
  task :reset do
    Sequel::Migrator.apply(DB, migrations_dir, 0)
    Sequel::Migrator.apply(DB, migrations_dir)
  end

  desc "Seed the database"
  task :seed do
    rack_env = ENV["RACK_ENV"] || "development"
    %x("RACK_ENV=#{rack_env} bundle exec ruby db/seeds.rb")
  end
end

namespace :g do
  task :migration, :fname do |t, args|
    require "fileutils"

    args.with_defaults(fname: "new_migration")
    Dir.chdir("db/migrations") do
      timestamp = Time.now.strftime("%Y%m%d%H%M")
      filename = "#{timestamp}_#{args[:fname]}.rb"
      File.open(filename, "w") do |f|
        f << <<SCAFFOLD
Sequel.migration do
  up do
  end

  down do
  end
end
SCAFFOLD
      end
    end
  end
end

namespace :routers do
  desc "Refresh data on routers (source: torstatus.blutmagie.de)"
  task :refresh do
    RefreshRouters.execute
  end
end

task default: :test

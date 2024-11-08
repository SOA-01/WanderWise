# frozen_string_literal: true

require 'database_cleaner'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
DatabaseCleaner.url_allowlist = [ENV['DATABASE_URL']]

# Helper to clean database during test runs
class DatabaseHelper
  def self.setup_database_cleaner
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.start
  end

  def self.wipe_database
    WanderWise::App.db.run('PRAGMA foreign_keys = OFF')
    DatabaseCleaner.clean
    WanderWise::App.db.run('PRAGMA foreign_keys = ON')
  end
end

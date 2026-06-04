# frozen_string_literal: true

require_relative "../app"
require "capybara"
require "capybara/minitest"
require "database_cleaner/sequel"

app = App
app.opts[:config] = Infra::Config
app.freeze

Capybara.app = app

module Infra
  class IntegrationTest < Minitest::Test
    include Capybara::DSL
    include Capybara::Minitest::Assertions

    PUBLIC_CONN = Sequel.connect(Config.db.uri, search_path: "public")
    EN57_CONN = Sequel.connect(Config.db.uri, search_path: "en57")

    def event_store = Config.event_store

    def run(*args, &block)
      DatabaseCleaner[:sequel].db = PUBLIC_CONN
      DatabaseCleaner[:sequel].strategy = :truncation, {except: %w[en57_schema_info]}

      DatabaseCleaner[:sequel, db: EN57_CONN].tap do |cleaner|
        cleaner.strategy = :truncation
      end

      Capybara.current_driver = :selenium_headless

      DatabaseCleaner.cleaning { super }
    end

    def teardown
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
end

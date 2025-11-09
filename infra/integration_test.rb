# frozen_string_literal: true

require_relative "../app"
require "capybara"
require "capybara/minitest"

app = App
app.opts[:config] = Infra::Config
app.freeze

Capybara.app = app

module Infra
  class IntegrationTest < Minitest::Test
    include Capybara::DSL
    include Capybara::Minitest::Assertions

    def event_store = Infra::Config.event_store

    def run(*args, &block)
      Infra::Config.db.transaction(rollback: :always, auto_savepoint: true) { super }
    end

    def teardown
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
end

# frozen_string_literal: true

require "minitest/test_task"
require "standard/rake"

Minitest::TestTask.create :test do |t|
  t.test_prelude = %(require_relative "boot")
  t.test_globs = ["*/**/test_*.rb"]
end

task default: %i[test standard]

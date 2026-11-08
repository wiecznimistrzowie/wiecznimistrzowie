# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:default)

%w[infra admin cms].each { require_relative "#{it}/loader" }

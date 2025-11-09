# frozen_string_literal: true

require_relative "app"

app = App
app.opts[:config] = Infra::Config
app.freeze

run app

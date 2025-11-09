# frozen_string_literal: true

module Infra
  class QueryBus
    UnregisteredHandler = Class.new(StandardError)
    MultipleHandlers = Class.new(StandardError)

    def initialize
      @registry = Concurrent::Map.new
    end

    def register(klass, handler)
      @registry.compute(klass) do |old_handler|
        raise MultipleHandlers.new("Multiple handlers not allowed for #{klass}") if old_handler

        handler
      end
    end

    def call(query)
      @registry
        .fetch(query.class) { raise UnregisteredHandler.new("Missing handler for #{query.class}") }
        .call(query)
    end
  end
end

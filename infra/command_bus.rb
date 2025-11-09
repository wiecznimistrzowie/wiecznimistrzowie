# frozen_string_literal: true

module Infra
  class CommandBus
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

    def call(command)
      @registry
        .fetch(command.class) { raise UnregisteredHandler.new("Missing handler for #{command.class}") }
        .call(command)
    end
  end
end

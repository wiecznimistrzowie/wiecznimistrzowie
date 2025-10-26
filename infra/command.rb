# frozen_string_literal: true

module Infra
  class InvalidCommand < StandardError
    attr_reader :error

    def initialize(error)
      @error = error

      super(error.message)
    end
  end

  class Command < Literal::Data
    extend Types

    def self.new(*, **)
      super
    rescue Literal::TypeError => e
      raise InvalidCommand.new(e)
    end
  end
end

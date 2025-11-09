# frozen_string_literal: true

module Infra
  class InvalidQuery < StandardError
    attr_reader :error

    def initialize(error)
      @error = error

      super(error.message)
    end
  end

  class Query < Literal::Data
    extend Types

    def self.new(*, **)
      super
    rescue Literal::TypeError => e
      raise InvalidQuery.new(e)
    end
  end
end

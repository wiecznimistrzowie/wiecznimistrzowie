# frozen_string_literal: true

module Infra
  class InvalidDomainEvent < StandardError
    attr_reader :error

    def initialize(error)
      @error = error

      super(error.message)
    end
  end

  class DomainEvent < Literal::Data
    extend Types

    def self.new(*, **)
      super
    rescue Literal::TypeError => e
      raise InvalidDomainEvent.new(e)
    end
  end
end

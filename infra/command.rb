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

    prop :correlation_id, _Uuid, default: -> { SecureRandom.uuid_v4 }
    prop :current_time, Time, default: -> { Time.now }

    def self.new(*, **)
      super
    rescue Literal::TypeError => e
      raise InvalidCommand.new(e)
    end
  end
end

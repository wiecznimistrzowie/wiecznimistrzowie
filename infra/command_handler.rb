# frozen_string_literal: true

module Infra
  class CommandHandler
    include Dry::Monads[:result]

    def initialize(decider:, stream:)
      @decider = decider
      @event_store = Config.event_store
      @stream = stream
    end

    def call(command)
      stream_name = @stream.build(command)

      events, expected_version = read_stream(stream_name)

      state = events.reduce(@decider.initial_state, &@decider.evolve)
      new_events = @decider.decide(command, state)
      append_to_stream(new_events, stream_name, expected_version)

      Success(new_events)
    rescue RubyEventStore::WrongExpectedEventVersion
      Failure(:wrong_expected_version)
    end

    private

    def read_stream(stream_name)
      events = @event_store.read.stream(stream_name).map(&method(:deserialize))

      [events, events.size - 1]
    end

    def append_to_stream(events, stream_name, expected_version)
      @event_store.publish(
        events.map(&method(:serialize)),
        stream_name: stream_name,
        expected_version: expected_version
      )
    end

    def serialize(event)
      EventStoreEvent.new(data: event.to_h, metadata: {event_type: event.class.name})
    end

    def deserialize(event)
      Object.const_get(event.event_type).new(**event.data)
    end
  end
end

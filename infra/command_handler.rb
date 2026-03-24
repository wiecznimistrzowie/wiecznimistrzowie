# frozen_string_literal: true

module Infra
  class CommandHandler
    include Dry::Monads[:result]

    def initialize(decider:, events:, tags: [])
      @decider = decider
      @event_store = Config.event_store
      @event_types = events.map(&:name)
      @tags = tags
    end

    def call(command)
      query = build_query(command, @event_types, @tags)

      events, max_sequence = read_stream(query)

      state = events.reduce(@decider.initial_state, &@decider.evolve)
      new_events = @decider.decide(command, state)

      result = append_to_stream(new_events, query, max_sequence)

      if result.any?
        Success(new_events)
      else
        Failure(:wrong_expected_version)
      end
    end

    private

    def build_query(command, event_types, tags)
      EventStore::Query.new(event_types) do |query|
        tags.each { query.with(it, command.send(it)) }
      end
    end

    def read_stream(query)
      events = @event_store.read(query: query)

      [events.map(&method(:deserialize)), events.empty? ? 0 : events.last.sequence]
    end

    def append_to_stream(events, query, max_sequence)
      @event_store.append(
        events.map(&method(:serialize)),
        condition: EventStore::AppendCondition.new(
          fail_if_events_match: query,
          after: max_sequence
        )
      )
    end

    def serialize(event)
      EventStore::Event.new(
        sequence: -1,
        event_id: SecureRandom.uuid_v7,
        event_type: event.class.name,
        data: event.to_h,
        metadata: {}
      )
    end

    def deserialize(event)
      Object.const_get(event.event_type).new(**event.data.transform_keys(&:to_sym))
    end
  end
end

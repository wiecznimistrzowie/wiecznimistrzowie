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
      query = @event_store
        .read
        .of_type(*@event_types)
        .with_tag(*command.map_tags(@tags))

      events, max_sequence = read_stream(query)

      state = events.reduce(@decider.initial_state, &@decider.evolve)
      new_events = @decider.decide(command, state)

      append_to_stream(new_events, query, max_sequence)

      Success(new_events)
    rescue En57::AppendConditionViolated
      Failure(:race_condition_detected)
    end

    private

    def build_query(command, event_types, tags)
      DCB::Query.new(event_types) do |query|
        tags.each { query.with(it, command.send(it)) }
      end
    end

    def read_stream(query)
      events = query.each_with_position.to_a

      [
        events.map(&:first).map(&method(:deserialize)),
        events.empty? ? 0 : events.last.last
      ]
    end

    def append_to_stream(events, query, max_sequence)
      @event_store.append(
        events.map(&method(:serialize)),
        fail_if: query.after(max_sequence)
      )
    end

    def serialize(event)
      En57::Event.new(
        type: event.class.name,
        data: event.to_h,
        tags: event.to_tags
      )
    end

    def deserialize(event)
      Object.const_get(event.type).new(**event.data.transform_keys(&:to_sym))
    end
  end
end

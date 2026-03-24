# frozen_string_literal: true

module Infra
  class EventSourcedQueryHandler
    def initialize(view:, events:, tags: [])
      @view = view.lmap_on_event(method(:deserialize))
      @event_store = Config.event_store
      @event_types = events.map(&:name)
      @tags = tags
    end

    def call(query)
      event_store_query = EventStore::Query.new(*@event_types) do |q|
        @tags.each { q.with(it, query.send(it)) }
      end

      @event_store.read(query: event_store_query).reduce(@view.initial_state, &@view.evolve)
    end

    private

    def deserialize(event)
      Object.const_get(event.event_type).new(**event.data.transform_keys(&:to_sym))
    end
  end
end

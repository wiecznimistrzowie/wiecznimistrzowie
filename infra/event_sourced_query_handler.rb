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
      @event_store
        .read
        .of_type(*@event_types)
        .with_tag(*@tags.map { "#{it}:#{query.public_send(it)}" })
        .each
        .reduce(@view.initial_state, &@view.evolve)
    end

    private

    def deserialize(event)
      Object.const_get(event.type).new(**event.data)
    end
  end
end

# frozen_string_literal: true

module Infra
  class EventSourcedQueryHandler
    def initialize(view:, stream:)
      @view = view.lmap_on_event(method(:deserialize))
      @event_store = Config.event_store
      @stream = stream
    end

    def call(query)
      stream_name = @stream.build(query)

      @event_store
        .read
        .stream(stream_name)
        .reduce(@view.initial_state, &@view.evolve)
    end

    private

    def deserialize(event)
      Object.const_get(event.event_type).new(**event.data)
    end
  end
end

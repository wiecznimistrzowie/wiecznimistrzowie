# frozen_string_literal: true

module Infra
  class EventStoreEvent < RubyEventStore::Event
    def deconstruct_keys(_keys)
      {event_id: event_id, metadata: metadata, data: data}
    end
  end
end

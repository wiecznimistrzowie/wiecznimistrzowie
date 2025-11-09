# frozen_string_literal: true

module Infra
  class EventStoreEvent < RubyEventStore::Event
    def deconstruct_keys(_keys)
      {event_id: event_id, metadata: metadata.to_h, data: data, event_type: event_type}
    end
  end
end

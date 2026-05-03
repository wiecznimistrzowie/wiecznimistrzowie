# frozen_string_literal: true

module Infra
  class MaterializedEventSourcedQueryHandler
    def initialize(table:, view:, events:, tags: [])
      @table = table
      @view = view.lmap_on_event(method(:deserialize))
      @db = Config.db
      @event_store = Config.event_store
      @event_types = events.map(&:name)
      @tags = tags
    end

    def call(query)
      if @tags.empty?
        materialize_collection(query)
      else
        materialize_record(query)
      end
    end

    private
    
    def materialize_collection(query)
      state = @db[@table].all.each_with_object({}) { |record, acc| acc[record["id"]] = record }
      event_store_query = EventStore::Query.new(*@event_types)
      @event_store.read(query: event_store_query).reduce(state, &@view.evolve)
      
    end
      
    def materialize_record(query)
      state = @db[@table].all.each_with_object({}) { |record, acc| acc[record["id"]] = record }

      event_store_query = EventStore::Query.new(*@event_types) do |q|
        @tags.each { q.with(it, query.send(it)) }
      end

      @event_store.read(
        query: event_store_query,
        options: EventStore::ReadOptions.new(sequence_position: record.max_sequence)
      ).reduce(state, &@view.evolve)
    end

    def deserialize(event)
      Object.const_get(event.event_type).new(**event.data.transform_keys(&:to_sym))
    end
  end
end

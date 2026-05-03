# frozen_string_literal: true

module Infra
  module QueryHandlers
    class MaterializedCollection
      # @param table [String] the name of the table in the database
      # @param view [Decider::View] the view to use for materialization
      # @param events [Array<Class>] the list of event classes to subscribe to
      def initialize(table:, view:, events:)
        @table = table
        @view = view.lmap_on_event(method(:deserialize))
        @event_types = events.map(&:name)
        @db = Config.db
        @event_store = Config.event_store
        @identifier = "id"
      end

      def call(query)
        state = @db[@table].all.each_with_object({}) { |record, acc| acc[record[@identifier]] = record }
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
end

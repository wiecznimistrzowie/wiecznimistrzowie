# frozen_string_literal: true

module Infra
  module EventStore
    ReadOptions = Data.define(:sequence_position)

    class Client
      # Initializes a new EventStore::Client.
      #
      # @param db [Sequel::Database] The database to use for the event store.
      def initialize(db: DB)
        @db = db
      end

      # Reads events from the event store.
      #
      # @param query [Query] The query to apply to the event store.
      # @param options [ReadOptions] The read options.
      # @return [Array<Event>] The events matching the query.
      def read(query:, options: ReadOptions.new(sequence_position: 0))
        @db.select(:sequence, :event_id, :event_type, :metadata, :data)
          .from(:events)
          .then { query.apply(it) }
          .where { sequence >= options.sequence_position }
          .map { Event.new(**it) }
      end

      # Appends events to the event store.
      #
      # @param events [Array<Event>] The events to append.
      # @param condition [AppendCondition] The condition for appending events.
      def append(events, condition:)
        @db[:events].returning(Sequel.lit("*")).with(
          :context,
          @db.select(Sequel.function(:max, :sequence).as(:max_sequence)).from(:events).then { condition.apply(it) }
        ).insert(
          %i[event_id event_type data metadata],
          @db[:context].select(
            Sequel.pg_array_op(Sequel.pg_array(events.map(&:event_id), :uuid)).unnest.as(:event_id),
            Sequel.pg_array_op(Sequel.pg_array(events.map(&:event_type), :text)).unnest.as(:event_type),
            Sequel.pg_array_op(Sequel.pg_array(events.map { it.data.to_json }, :jsonb)).unnest.as(:data),
            Sequel.pg_array_op(Sequel.pg_array(events.map { it.metadata.to_json }, :jsonb)).unnest.as(:metadata)
          ).where {
            Sequel.function(:coalesce, Sequel[:context][:max_sequence], 0) <= condition.after
          }
        )
      end

      def subscribe(*, **)
      end

      def with_metadata(**metadata, &block)
        block.call
      end
    end
  end
end

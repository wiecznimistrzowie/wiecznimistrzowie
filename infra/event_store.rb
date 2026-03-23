# frozen_string_literal: true

module Infra
  class EventStore
    class Query
      def initialize(*event_types)
        @event_types = event_types
        @tags = {}
      end

      def with(tag, value)
        tag = tag.to_sym

        warn "Tag #{tag} already set" if @tags.key?(tag)
        @tags[tag] = value

        self
      end

      def apply(context)
        if @tags.empty?
          context.where(event_type: @event_types)
        else
          context.where(event_type: @event_types).where(
            Sequel.pg_jsonb_op(:data).contains(@tags)
          )
        end
      end
    end

    class AppendCondition
      attr_reader :after

      def initialize(fail_if_events_match:, after: 0)
        @fail_if_events_match = fail_if_events_match
        @after = after
      end

      def apply(context) = @fail_if_events_match.apply(context)
    end

    ReadOptions = Data.define(:sequence_position)

    def initialize(db: DB)
      @db = db
    end

    def read(query:, options: ReadOptions.new(sequence_position: 0))
      @db.select(:sequence, :event_id, :metadata, :data, :event_type)
        .from(:events)
        .then { query.apply(it) }
        .where { sequence >= options.sequence_position }
        .to_a
    end

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
  end
end

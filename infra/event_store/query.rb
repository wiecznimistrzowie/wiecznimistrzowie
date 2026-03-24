# frozen_string_literal: true

module Infra
  module EventStore
    class Query
      # Creates a new query that filters events by type and tags.
      #
      # @param event_types [Array<Symbol>] The event types to filter by.
      # @yield [self] Yields the query object to the block.
      def initialize(*event_types, &block)
        @event_types = event_types
        @tags = {}

        yield self if block_given?
      end

      # Adds a tag filter to the query.
      #
      # @param tag [Symbol] The tag to filter by.
      # @param value [String] The value to filter by.
      # @return [self] The query object.
      def with(tag, value)
        tag = tag.to_sym

        warn "Tag #{tag} already set" if @tags.key?(tag)
        @tags[tag] = value

        self
      end

      # Applies the query to the given context.
      #
      # @param context [Sequel::Dataset] The context to apply the query to.
      # @return [Sequel::Dataset] The filtered dataset.
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
  end
end

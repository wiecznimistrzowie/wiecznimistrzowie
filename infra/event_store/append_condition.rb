# frozen_string_literal: true

module Infra
  module EventStore
    class AppendCondition
      # @return [Integer] The sequence position after which to append.
      attr_reader :after

      # Initializes a new AppendCondition.
      #
      # @param fail_if_events_match [Query] The query to match existing events.
      # @param after [Integer] The sequence position after which to append.
      def initialize(fail_if_events_match:, after: 0)
        @fail_if_events_match = fail_if_events_match
        @after = after
      end

      # Applies the append condition to the given context.
      #
      # @param context [Sequel::Dataset] The context to apply the condition to.
      # @return [Sequel::Dataset] The filtered dataset.
      def apply(context) = @fail_if_events_match.apply(context)
    end
  end
end

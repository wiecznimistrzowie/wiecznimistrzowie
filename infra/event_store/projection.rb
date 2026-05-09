# frozen_string_literal: true

module Infra
  module EventStore
    class MaterializedView
      def initialize(state_repository:, view:)
        @state_repository = state_repository
        @view = view
      end

      def call(event)
        state = @state_repository.fetch_state(event) || @view.initial_state
        new_state = @view.evolve(state, event)
        @state_repository.save(new_state)
      end
    end
  end
end
# frozen_string_literal: true

module Infra
  module DeciderTestHelpers
    def decider
      raise NotImplementedError, "You must provide a decider"
    end

    def given(events)
      @state = events.reduce(decider.initial_state, &decider.evolve)

      self
    end

    def when(command)
      @events = decider.decide(command, @state)

      self
    end

    def then(events)
      assert_equal events, @events
    end
  end
end

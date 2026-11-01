# frozen_string_literal: true

module CMS
  module AddingLocality
    Decider = Decider.define do
      initial_state :none

      decide AddLocality, :none do
        emit LocalityWasAdded.new(
          locality_id: command.locality_id,
          name: command.name
        )
      end

      evolve LocalityWasAdded do
        :added
      end
    end
  end
end

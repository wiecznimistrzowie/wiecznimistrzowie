# frozen_string_literal: true

module CMS
  module ShowLocality
    ReadModel = Decider::View.define do
      initial_state :none

      evolve LocalityWasAdded do
        Locality.new(**event.to_h)
      end
    end
  end
end

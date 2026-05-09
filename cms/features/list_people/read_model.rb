# frozen_string_literal: true

module CMS
  module ListPeople
    ReadModel = Decider::View.define do
      initial_state :none

      evolve AddingPerson::PersonWasAdded do
        Person.new(**event.to_h)
      end
    end
  end
end

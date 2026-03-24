# frozen_string_literal: true

module CMS
  module ListPeople
    ReadModel = Decider::View.define do
      initial_state []

      evolve AddingPerson::PersonWasAdded do
        state.push(Person.new(**event.to_h))
      end
    end
  end
end

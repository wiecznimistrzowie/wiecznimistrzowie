# frozen_string_literal: true

module CMS
  module ListPeople
    ReadModel = Decider::View.define do
      initial_state :empty
      
      evolve :empty, AddingPerson::PersonWasAdded do
        [Person.new(**event.to_h)]
      end

      evolve AddingPerson::PersonWasAdded do
        state.push(Person.new(**event.to_h))
      end
    end
  end
end

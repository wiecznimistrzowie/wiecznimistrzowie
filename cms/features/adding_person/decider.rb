# frozen_string_literal: true

module CMS
  module AddingPerson
    Decider = Decider.define do
      initial_state :none

      decide AddPerson do
        emit PersonWasAdded.new(
          person_id: command.person_id,
          first_name: command.first_name,
          last_name: command.last_name,
          date_of_birth: command.date_of_birth,
          date_of_death: command.date_of_death
        )
      end
    end
  end
end

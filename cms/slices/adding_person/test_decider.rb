# frozen_string_literal: true

module CMS
  module AddingPerson
    class TestDecider < Minitest::Test
      include Infra::DeciderTestHelpers

      def decider = Decider

      def test_emits_person_was_added
        person_id = SecureRandom.uuid_v7

        given(
          []
        ).when(
          AddPerson.new(
            person_id: person_id,
            first_name: "Adam",
            last_name: "Wójcik",
            date_of_birth: "1970-04-20",
            date_of_death: "2017-08-26"
          )
        ).then(
          [
            PersonWasAdded.new(
              person_id: person_id,
              first_name: "Adam",
              last_name: "Wójcik",
              date_of_birth: Date.new(1970, 4, 20),
              date_of_death: Date.new(2017, 8, 26)
            )
          ]
        )
      end
    end
  end
end

# frozen_string_literal: true

module CMS
  module AddingLocality
    class TestDecider < Minitest::Test
      include Infra::DeciderTestHelpers

      def decider = Decider

      def test_emits_locality_was_added
        locality_id = SecureRandom.uuid_v7

        given(
          []
        ).when(
          AddLocality.new(locality_id: locality_id, name: "Kraków")
        ).then(
          [
            LocalityWasAdded.new(locality_id: locality_id, name: "Kraków")
          ]
        )
      end

      def test_does_nothing_when_locality_already_added
        locality_id = SecureRandom.uuid_v7

        given(
          [
            LocalityWasAdded.new(locality_id: locality_id, name: "Kraków")
          ]
        ).when(
          AddLocality.new(locality_id: locality_id, name: "Kraków")
        ).then(
          []
        )
      end
    end
  end
end

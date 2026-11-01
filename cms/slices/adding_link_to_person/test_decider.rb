# frozen_string_literal: true

module CMS
  module AddingLinkToPerson
    class TestDecider < Minitest::Test
      include Infra::DeciderTestHelpers

      def decider = Decider

      def test_emits_link_was_added_to_person
        person_id = SecureRandom.uuid_v7

        given(
          [
            person_was_added(person_id)
          ]
        ).when(
          AddLinkToPerson.new(person_id: person_id, url: "https://example.com", label: "Example")
        ).then(
          [
            LinkWasAddedToPerson.new(person_id: person_id, url: "https://example.com", label: "Example")
          ]
        )
      end

      def test_allows_another_link_with_different_url
        person_id = SecureRandom.uuid_v7

        given(
          [
            person_was_added(person_id),
            LinkWasAddedToPerson.new(person_id: person_id, url: "https://example.com", label: "Example")
          ]
        ).when(
          AddLinkToPerson.new(person_id: person_id, url: "https://example.org", label: "Other")
        ).then(
          [
            LinkWasAddedToPerson.new(person_id: person_id, url: "https://example.org", label: "Other")
          ]
        )
      end

      def test_does_nothing_when_url_already_added
        person_id = SecureRandom.uuid_v7

        given(
          [
            person_was_added(person_id),
            LinkWasAddedToPerson.new(person_id: person_id, url: "https://example.com", label: "Example")
          ]
        ).when(
          AddLinkToPerson.new(person_id: person_id, url: "https://example.com", label: "Another label")
        ).then(
          []
        )
      end

      def test_does_nothing_when_person_does_not_exist
        given(
          []
        ).when(
          AddLinkToPerson.new(person_id: SecureRandom.uuid_v7, url: "https://example.com", label: "Example")
        ).then(
          []
        )
      end

      private

      def person_was_added(person_id)
        PersonWasAdded.new(
          person_id: person_id,
          first_name: "Adam",
          last_name: "Wójcik",
          date_of_birth: "1970-04-20",
          date_of_death: "2017-08-26"
        )
      end
    end
  end
end

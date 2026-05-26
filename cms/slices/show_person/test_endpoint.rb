# frozen_string_literal: true

module CMS
  module ShowPerson
    class TestEndpoint < Infra::IntegrationTest
      def test_not_found
        visit("/cms/people/#{SecureRandom.uuid_v7}")

        assert_text "Not found"
      end

      def test_success
        person_id = SecureRandom.uuid_v7
        event_store.append(
          [
            En57::Event.new(
              type: "CMS::PersonWasAdded",
              data: {
                person_id: person_id,
                first_name: "Adam",
                last_name: "Wójcik",
                date_of_birth: "1970-04-20",
                date_of_death: "2017-08-26"
              },
              tags: ["person_id:#{person_id}"]
            )
          ]
        )

        visit("/cms/people/#{person_id}")

        assert_text "Adam"
        assert_text "Wójcik"
        assert_text "1970-04-20"
        assert_text "2017-08-26"
      end
    end
  end
end

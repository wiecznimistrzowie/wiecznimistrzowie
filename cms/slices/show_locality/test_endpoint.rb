# frozen_string_literal: true

module CMS
  module ShowLocality
    class TestEndpoint < Infra::IntegrationTest
      include TestHelpers::Authentication

      def test_not_found
        sign_in_admin

        visit("/cms/localities/#{SecureRandom.uuid_v7}")

        assert_text "Not found"
      end

      def test_success
        sign_in_admin

        locality_id = SecureRandom.uuid_v7
        event_store.append(
          [
            En57::Event.new(
              type: "CMS::LocalityWasAdded",
              data: {
                locality_id: locality_id,
                name: "Kraków"
              },
              tags: ["locality_id:#{locality_id}"]
            )
          ]
        )

        visit("/cms/localities/#{locality_id}")

        assert_text "Kraków"
        assert_text locality_id
      end
    end
  end
end

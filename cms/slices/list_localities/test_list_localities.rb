# frozen_string_literal: true

module CMS::ListLocalities
  class TestListLocalities < Infra::IntegrationTest
    include CMS::TestHelpers::Authentication

    def test_nothing_projected
      sign_in_admin

      visit("/admin/cms/localities")

      assert_equal 0, all("tbody tr").size
    end

    def test_list_alphabetically
      sign_in_admin

      warszawa_id = SecureRandom.uuid_v7
      krakow_id = SecureRandom.uuid_v7
      gdansk_id = SecureRandom.uuid_v7

      event_store.append(
        [
          En57::Event.new(
            type: "CMS::LocalityWasAdded",
            data: {locality_id: warszawa_id, name: "Warszawa"},
            tags: ["locality_id:#{warszawa_id}"]
          ),
          En57::Event.new(
            type: "CMS::LocalityWasAdded",
            data: {locality_id: krakow_id, name: "Kraków"},
            tags: ["locality_id:#{krakow_id}"]
          ),
          En57::Event.new(
            type: "CMS::LocalityWasAdded",
            data: {locality_id: gdansk_id, name: "Gdańsk"},
            tags: ["locality_id:#{gdansk_id}"]
          )
        ]
      )

      visit("/admin/cms/localities")

      names = page.all("[data-testid=locality-name]").map(&:text)

      assert_equal ["Gdańsk", "Kraków", "Warszawa"], names
    end
  end
end

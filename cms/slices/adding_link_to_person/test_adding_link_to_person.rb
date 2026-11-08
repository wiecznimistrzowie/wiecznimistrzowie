# frozen_string_literal: true

module CMS::AddingLinkToPerson
  class TestAddingLinkToPerson < Infra::IntegrationTest
    include CMS::TestHelpers::Authentication

    def test_success
      sign_in_admin

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

      visit("/admin/cms/people/#{person_id}/links/add")

      within("[data-testid=adding-link-to-person]") do
        fill_in("url", with: "https://pl.wikipedia.org/wiki/Adam_Wojcik")
        fill_in("label", with: "Wikipedia")

        click_on("Save")
      end

      assert_current_path "/admin/cms/people/#{person_id}"
    end
  end
end

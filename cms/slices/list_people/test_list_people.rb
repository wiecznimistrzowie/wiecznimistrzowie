# frozen_string_literal: true

module CMS::AddingPerson
  class TestListPeople < Infra::IntegrationTest
    include CMS::TestHelpers::Authentication

    def test_nothing_projected
      sign_in_admin

      visit("/cms/people")

      assert_equal 0, all("tbody tr").size
    end

    def test_list_alphabetically
      sign_in_admin

      adam_id = SecureRandom.uuid_v7
      marian_id = SecureRandom.uuid_v7

      event_store.append(
        [
          En57::Event.new(
            type: "CMS::PersonWasAdded",
            data: {
              person_id: adam_id,
              first_name: "Adam",
              last_name: "Wójcik",
              date_of_birth: "1970-04-20",
              date_of_death: "2017-08-26"
            },
            tags: ["person_id:#{adam_id}"]
          ),
          En57::Event.new(
            type: "CMS::PersonWasAdded",
            data: {
              person_id: marian_id,
              first_name: "Marian",
              last_name: "Dziurowicz",
              date_of_birth: "1935-07-16",
              date_of_death: "2002-06-21"
            },
            tags: ["person_id:#{marian_id}"]
          )
        ]
      )

      visit("/cms/people")

      last_names = page.all("[data-testid=person-last-name]").map(&:text)

      assert_equal ["Dziurowicz", "Wójcik"], last_names
    end
  end
end

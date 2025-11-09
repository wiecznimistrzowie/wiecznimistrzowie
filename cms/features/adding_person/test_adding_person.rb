# frozen_string_literal: true

module CMS::AddingPerson
  class TestAddingPerson < Infra::IntegrationTest
    def test_add_person
      skip "Read model not implemented yet"
      visit("/cms/people/add")

      within("form") do
        fill_in("first_name", with: "Marian")
        fill_in("last_name", with: "Dziurowicz")
        fill_in("date_of_birth", with: "2010-01-01")
        fill_in("date_of_death", with: "2010-01-01")

        click_on("Save")
      end

      assert_includes page.text, "Marian Dziurowicz"
    end
  end
end

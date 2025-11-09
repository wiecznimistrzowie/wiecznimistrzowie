# frozen_string_literal: true

module CMS::AddingPerson
  class TestAddingPerson < Infra::IntegrationTest
    def test_add_person
      visit("/cms/people/add")

      within("form") do
        fill_in("first_name", with: "Marian")
        fill_in("last_name", with: "Dziurowicz")
        fill_in("date_of_birth", with: "1935-07-16")
        fill_in("date_of_death", with: "2002-06-21")

        click_on("Save")
      end

      assert_includes page.text, "Marian"
      assert_includes page.text, "Dziurowicz"
      assert_includes page.text, "1935-07-16"
      assert_includes page.text, "2002-06-21"
    end
  end
end

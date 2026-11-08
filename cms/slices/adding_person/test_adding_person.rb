# frozen_string_literal: true

module CMS::AddingPerson
  class TestAddingPerson < Infra::IntegrationTest
    include CMS::TestHelpers::Authentication

    def test_success
      sign_in_admin

      visit("/admin/cms/people/add")

      within("[data-testid=adding-person]") do
        fill_in("first_name", with: "Marian")
        fill_in("last_name", with: "Dziurowicz")
        fill_in("date_of_birth", with: "1935-07-16")
        fill_in("date_of_death", with: "2002-06-21")

        click_on("Save")
      end

      assert_current_path %r(/admin/cms/people/[0-9a-f-]{36})
    end
  end
end

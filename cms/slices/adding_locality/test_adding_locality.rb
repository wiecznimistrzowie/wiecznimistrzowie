# frozen_string_literal: true

module CMS::AddingLocality
  class TestAddingLocality < Infra::IntegrationTest
    include CMS::TestHelpers::Authentication

    def test_success
      sign_in_admin

      visit("/cms/localities/add")

      within("[data-testid=adding-locality]") do
        fill_in("name", with: "Kraków")

        click_on("Save")
      end

      assert_current_path %r(/cms/localities/[0-9a-f-]{36})
    end
  end
end

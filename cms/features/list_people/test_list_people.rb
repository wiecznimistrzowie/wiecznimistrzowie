# frozen_string_literal: true

module CMS::AddingPerson
  class TestListPeople < Infra::IntegrationTest
    def test_nothing_projected
      visit("/cms/people")

      assert_equal 0, all("tbody tr").size
    end
  end
end

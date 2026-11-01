# frozen_string_literal: true

module CMS::ListPersonLinks
  class TestListPersonLinks < Infra::IntegrationTest
    include CMS::TestHelpers::Authentication

    def test_nothing_projected
      sign_in_admin

      visit("/cms/people/#{SecureRandom.uuid_v7}/links")

      assert_equal 0, all("tbody tr").size
    end

    def test_list_by_label_ascending_for_given_person_only
      sign_in_admin

      person_id = SecureRandom.uuid_v7
      other_person_id = SecureRandom.uuid_v7

      event_store.append(
        [
          link_was_added(person_id, "Wikipedia", "https://pl.wikipedia.org/wiki/Adam"),
          link_was_added(person_id, "Archive", "https://archive.example.com/adam"),
          link_was_added(other_person_id, "Aaa", "https://other.example.com"),
          link_was_added(person_id, "Homepage", "https://adam.example.com")
        ]
      )

      visit("/cms/people/#{person_id}/links")

      labels = page.all("[data-testid=link-label]").map(&:text)
      urls = page.all("[data-testid=link-url]").map(&:text)

      assert_equal ["Archive", "Homepage", "Wikipedia"], labels
      assert_equal [
        "https://archive.example.com/adam",
        "https://adam.example.com",
        "https://pl.wikipedia.org/wiki/Adam"
      ], urls
    end

    private

    def link_was_added(person_id, label, url)
      En57::Event.new(
        type: "CMS::LinkWasAddedToPerson",
        data: {person_id: person_id, url: url, label: label},
        tags: ["person_id:#{person_id}", "url:#{url}", "label:#{label}"]
      )
    end
  end
end

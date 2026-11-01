# frozen_string_literal: true

class App
  route("list_person_links") do |r|
    r.get "people", String, "links" do |person_id|
      CMS::ListPersonLinks::View.new(
        links: query_bus.call(CMS::ListPersonLinks::ByPersonId.new(person_id))
      ).call
    end
  end
end

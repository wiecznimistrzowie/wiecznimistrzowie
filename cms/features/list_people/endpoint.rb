# frozen_string_literal: true

class App
  route("list_people") do |r|
    r.get "people" do |r|
      CMS::ListPeople::View.new(
        people: query_bus.call(CMS::ListPeople::ByName.new)
      ).call
    end
  end
end

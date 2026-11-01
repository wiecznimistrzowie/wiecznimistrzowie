# frozen_string_literal: true

class App
  route("list_localities") do |r|
    r.get "localities" do
      CMS::ListLocalities::View.new(
        localities: query_bus.call(CMS::ListLocalities::ByName.new)
      ).call
    end
  end
end

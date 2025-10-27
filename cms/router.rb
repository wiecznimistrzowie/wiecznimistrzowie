# frozen_string_literal: true

class App
  hash_branch "cms" do |r|
    r.on "people" do
      r.get do
        CMS::Components::Layout.new(
          title: "People",
          content: CMS::ListPeople::View
        ).call
      end
    end
  end
end

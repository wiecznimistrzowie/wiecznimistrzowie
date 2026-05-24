# frozen_string_literal: true

class App
  route("show_person") do |r|
    r.get "people", String do |person_id|
      person = query_bus.call(
        CMS::ShowPerson::ByPersonId.new(person_id)
      )
  
      case person
      in :none
        "Not found"
      else
        CMS::ShowPerson::View.new(
          person: person
        ).call
      end
    end
  end
end

# frozen_string_literal: true

class App
  route("show_locality") do |r|
    r.get "localities", String do |locality_id|
      locality = query_bus.call(
        CMS::ShowLocality::ByLocalityId.new(locality_id)
      )

      case locality
      in :none
        "Not found"
      else
        CMS::ShowLocality::View.new(
          locality: locality
        ).call
      end
    end
  end
end

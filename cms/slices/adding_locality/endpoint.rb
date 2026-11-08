# frozen_string_literal: true

class App
  route("adding_locality") do |r|
    r.on "localities", "add" do
      r.get true do
        CMS::AddingLocality::View.new(app: self).call
      end

      r.post true do
        locality_id = SecureRandom.uuid_v7

        command = CMS::AddingLocality::AddLocality.new(
          locality_id: locality_id,
          name: r.params["name"]
        )

        case command_bus.call(command)
        in Success[CMS::LocalityWasAdded]
          response.status = 202
          response["HX-Location"] = {
            path: "/admin/cms/localities/#{locality_id}",
            target: "main"
          }.to_json
        in Failure(:race_condition_detected)
          CMS::AddingLocality::View.new(
            app: self,
            form_data: r.params
          ).call
        end
      end
    end
  end
end

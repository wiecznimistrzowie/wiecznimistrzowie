# frozen_string_literal: true

class App
  route("adding_person") do |r|
    r.on "people", "add" do
      r.get true do
        CMS::AddingPerson::View.new(app: self).call
      end

      r.post true do
        person_id = SecureRandom.uuid_v7

        command = CMS::AddingPerson::AddPerson.new(
          person_id: person_id,
          first_name: r.params["first_name"],
          last_name: r.params["last_name"],
          date_of_birth: r.params["date_of_birth"],
          date_of_death: r.params["date_of_death"]
        )

        case command_bus.call(command)
        in Success[CMS::PersonWasAdded]
          response.status = 202
          response["HX-Location"] = {
            path: "/cms/people/#{person_id}",
            target: "main"
          }.to_json
        in Failure(:wrong_expected_version)
          CMS::AddingPerson::View.new(
            app: self,
            form_data: r.params
          ).call
        end
      end
    end
  end
end

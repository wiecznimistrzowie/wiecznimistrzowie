# frozen_string_literal: true

class App
  route("adding_person") do |r|
    r.on "people", "add" do
      r.get true do
        CMS::AddingPerson::View.new(app: self).call
      end

      r.post true do
        command = CMS::AddingPerson::AddPerson.new(
          first_name: r.params["first_name"],
          last_name: r.params["last_name"],
          date_of_birth: r.params["date_of_birth"],
          date_of_death: r.params["date_of_death"]
        )

        case command_bus.call(command)
        in Success[CMS::AddingPerson::PersonWasAdded]
          r.redirect "/cms/people"
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

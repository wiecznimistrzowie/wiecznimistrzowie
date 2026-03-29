# frozen_string_literal: true

class App
  hash_branch "cms" do |r|
    if r.headers["HX-Request"]
      r.on "people" do
        r.get true do
          CMS::ListPeople::View.new(
            people: query_bus.call(CMS::ListPeople::ByName.new)
          ).call
        end

        r.on "add" do
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

        r.get String do |person_id|
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
    else
      CMS::Layout.new(current_path: r.path).call
    end
  end
end

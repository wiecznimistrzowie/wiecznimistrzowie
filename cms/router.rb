# frozen_string_literal: true

class App
  hash_branch "cms" do |r|
    r.on "people" do
      r.get true do
        CMS::Components::Layout.new(
          title: "People",
          content: CMS::ListPeople::View.new(
            people: query_bus.call(CMS::ListPeople::ByName.new)
          )
        ).call
      end

      r.on "add" do
        r.get true do
          CMS::Components::Layout.new(
            title: "Add person",
            content: CMS::AddingPerson::View.new(
              csrf_token: csrf_token("/cms/people/add")
            )
          ).call
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
            CMS::Components::Layout.new(
              title: "Add person",
              content: CMS::AddingPerson::View.new(
                form_data: r.params,
                csrf_token: csrf_token("/cms/people/add")
              )
            ).call
          end
        end
      end
    end
  end
end

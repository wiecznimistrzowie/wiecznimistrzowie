# frozen_string_literal: true

class App
  route("adding_link_to_person") do |r|
    r.on "people", String, "links", "add" do |person_id|
      r.get true do
        CMS::AddingLinkToPerson::View.new(app: self, person_id: person_id).call
      end

      r.post true do
        command = CMS::AddingLinkToPerson::AddLinkToPerson.new(
          person_id: person_id,
          url: r.params["url"],
          label: r.params["label"]
        )

        case command_bus.call(command)
        in Success[CMS::LinkWasAddedToPerson] | Success[]
          # Success[] means nothing was appended (the link is already there), which is fine.
          response.status = 202
          response["HX-Location"] = {
            path: "/cms/people/#{person_id}",
            target: "main"
          }.to_json
        in Failure(:race_condition_detected)
          CMS::AddingLinkToPerson::View.new(
            app: self,
            person_id: person_id,
            form_data: r.params
          ).call
        end
      end
    end
  end
end

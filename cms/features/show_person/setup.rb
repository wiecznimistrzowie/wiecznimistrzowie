# frozen_string_literal: true

module CMS::ShowPerson
  module Setup
    Infra::Config.query_bus.register(
      ByPersonId,
      Infra::EventSourcedQueryHandler.new(
        view: ReadModel,
        events: [CMS::AddingPerson::PersonWasAdded],
        tags: %i[person_id]
      )
    )
  end
end

# frozen_string_literal: true

module CMS
  module ShowPerson
    module Setup
      Infra::Config.query_bus.register(
        ByPersonId,
        Infra::EventSourcedQueryHandler.new(
          view: ReadModel,
          events: [PersonWasAdded],
          tags: %i[person_id]
        )
      )
    end
  end
end
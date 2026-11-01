# frozen_string_literal: true

module CMS
  module ListPersonLinks
    module Setup
      Infra::Config.query_bus.register(
        ByPersonId,
        Infra::EventSourcedQueryHandler.new(
          view: ReadModel,
          events: [LinkWasAddedToPerson],
          tags: %i[person_id]
        )
      )
    end
  end
end

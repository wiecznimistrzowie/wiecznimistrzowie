# frozen_string_literal: true

module CMS
  module ShowLocality
    module Setup
      Infra::Config.query_bus.register(
        ByLocalityId,
        Infra::EventSourcedQueryHandler.new(
          view: ReadModel,
          events: [LocalityWasAdded],
          tags: %i[locality_id]
        )
      )
    end
  end
end

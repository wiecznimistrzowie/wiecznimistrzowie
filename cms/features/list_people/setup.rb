# frozen_string_literal: true

module CMS
  module ListPeople
    module Setup
      # Projections not supported yet
      # Infra::Config.event_store.subscribe(
      #   Projector.new(db: Infra::Config.db),
      #   to: [AddingPerson::PersonWasAdded]
      # )
      # Infra::Config.query_bus.register(
      #   ByName, ->(_) { Infra::Config.db[:cms_people].order(:last_name, :first_name) }
      # )
      Infra::Config.query_bus.register(
        ByName,
        Infra::EventSourcedQueryHandler.new(
          view: ReadModel,
          events: [CMS::AddingPerson::PersonWasAdded]
        )
      )
    end
  end
end

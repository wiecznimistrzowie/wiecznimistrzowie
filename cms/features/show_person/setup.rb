# frozen_string_literal: true

module CMS::ShowPerson
  module Setup
    Infra::Config.query_bus.register(
      ByPersonId,
      Infra::EventSourcedQueryHandler.new(
        view: ReadModel,
        stream: Infra::Stream.new(
          name: "CMS::Person",
          tags: %i[person_id]
        )
      )
    )
  end
end

# frozen_string_literal: true

module CMS
  module AddingLocality
    module Setup
      Infra::Config.command_bus.register(
        AddLocality,
        Infra::CommandHandler.new(
          decider: Decider,
          events: [LocalityWasAdded],
          tags: %i[locality_id]
        )
      )
    end
  end
end

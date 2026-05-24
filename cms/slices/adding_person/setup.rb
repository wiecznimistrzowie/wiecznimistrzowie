# frozen_string_literal: true

module CMS
  module AddingPerson
    module Setup
      Infra::Config.command_bus.register(
        AddPerson,
        Infra::CommandHandler.new(
          decider: Decider,
          events: [PersonWasAdded],
          tags: %i[person_id]
        )
      )
    end
  end
end

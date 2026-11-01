# frozen_string_literal: true

module CMS
  module AddingLinkToPerson
    module Setup
      Infra::Config.command_bus.register(
        AddLinkToPerson,
        Infra::CommandHandler.new(
          decider: Decider,
          events: [PersonWasAdded, LinkWasAddedToPerson],
          tags: %i[person_id]
        )
      )
    end
  end
end

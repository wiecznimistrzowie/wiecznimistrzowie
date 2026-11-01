# frozen_string_literal: true

module CMS
  module AddingLinkToPerson
    Decider = Decider.define do
      initial_state :none

      decide AddLinkToPerson, Person do
        unless state.urls.include?(command.url)
          emit LinkWasAddedToPerson.new(
            person_id: command.person_id,
            url: command.url,
            label: command.label
          )
        end
      end

      evolve PersonWasAdded do
        Person.new(urls: [])
      end

      evolve Person, LinkWasAddedToPerson do
        state.with(urls: state.urls + [event.url])
      end
    end
  end
end

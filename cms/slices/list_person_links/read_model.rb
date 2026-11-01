# frozen_string_literal: true

module CMS
  module ListPersonLinks
    ReadModel = Decider::View.define do
      initial_state []

      evolve LinkWasAddedToPerson do
        link = Link.new(url: event.url, label: event.label)

        (state + [link]).sort_by { [it.label, it.url] }
      end
    end
  end
end

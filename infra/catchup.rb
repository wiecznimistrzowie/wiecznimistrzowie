# frozen_string_literal: true

module Infra
  class Catchup
    def initialize(materialized_view:, event_types:)
      @materialized_view = materialized_view
      @state_repository = materialized_view.state_repository
      @event_types = event_types.map(&:name)
      @event_store = Config.event_store
    end

    def call
      @event_store.read.of_type(*@event_types).after(@state_repository.current_position).each_with_position do |event, position|
        @materialized_view.call(event: deserialize(event), position: position)
      end
    end
    
    def deserialize(event)
      Object.const_get(event.type).new(**event.data)
    end
  end
end

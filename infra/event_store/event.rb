# frozen_string_literal: true

module Infra
  module EventStore
    Event = Data.define(:sequence, :event_id, :event_type, :metadata, :data)
  end
end

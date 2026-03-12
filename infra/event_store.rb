# frozen_string_literal: true

module Infra
  class EventStore
    Query = Data.define(:event_type, :tags)
    ReadOptions = Data.define(:sequence_position)

    def initialize(db: DB)
      @db = db
    end

    def read(query:, options: ReadOptions.new(sequence_position: 0))
    end
  end
end
# frozen_string_literal: true

module Infra
  class EventStoreClient < RubyEventStore::Client
    def initialize(
      mapper: RubyEventStore::Mappers::BatchMapper.new(
        RubyEventStore::Mappers::PipelineMapper.new(
          RubyEventStore::Mappers::Pipeline.new(
            {
              Symbol => {
                serializer: ->(v) { v.to_s },
                deserializer: ->(v) { v.to_sym }
              },
              Time => {
                serializer: ->(v) { v.iso8601(RubyEventStore::TIMESTAMP_PRECISION) },
                deserializer: ->(v) { Time.iso8601(v) }
              },
              Date => {
                serializer: ->(v) { v.iso8601 },
                deserializer: ->(v) { Date.iso8601(v) }
              },
              DateTime => {
                serializer: ->(v) { v.iso8601 },
                deserializer: ->(v) { DateTime.iso8601(v) }
              },
              BigDecimal => {
                serializer: ->(v) { v.to_s },
                deserializer: ->(v) { BigDecimal(v) }
              }
            }.reduce(RubyEventStore::Mappers::Transformation::PreserveTypes.new) do |preserve_types, (klass, options)|
              preserve_types.register(klass, **options)
            end,
            RubyEventStore::Mappers::Transformation::SymbolizeMetadataKeys.new
          )
        )
      ),
      repository: RubyEventStore::Sequel::EventRepository.new(sequel: DB, serializer: JSON)
    )
      super
    end
  end
end

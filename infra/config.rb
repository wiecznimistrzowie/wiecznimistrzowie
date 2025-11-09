# frozen_string_literal: true

require "logger"

module Infra
  Config = Data.define(
    :command_bus,
    :db,
    :event_store,
    :logger,
    :query_bus
  ).new(
    command_bus: CommandBus.new,
    db: DB,
    event_store: EventStoreClient.new,
    logger: Logger.new($stdout),
    query_bus: QueryBus.new
  )
end

# frozen_string_literal: true

require_relative "boot"

class App < Roda
  extend Forwardable
  include Dry::Monads[:result]

  def_delegators :config, :command_bus, :event_store, :query_bus

  opts[:root] = __dir__
  opts[:config] = Infra::Config

  plugin :common_logger
  plugin :flash
  plugin :named_routes
  plugin :hash_branches
  plugin :path
  plugin :public
  plugin :route_csrf
  plugin :sessions, secret: SecureRandom.base64(64)
  plugin :shared_vars

  require_relative "cms/router"

  def config
    opts[:config]
  end

  route do |r|
    request_id = request.env["HTTP_X_REQUEST_ID"] || SecureRandom.uuid

    r.public

    check_csrf!

    r.on "res" do
      require "ruby_event_store/browser/app"

      r.run RubyEventStore::Browser::App.for(event_store_locator: -> { event_store })
    end

    event_store.with_metadata(request_id: request_id, remote_ip: request.env["REMOTE_ADDR"]) do
      r.hash_branches

      r.root do
        "Wieczni Mistrzowie"
      end
    end
  end
end

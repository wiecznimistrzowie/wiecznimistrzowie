# frozen_string_literal: true

require_relative "boot"

class App < Roda
  opts[:root] = __dir__

  plugin :common_logger
  plugin :flash
  plugin :named_routes
  plugin :hash_branches
  plugin :path
  plugin :public
  plugin :route_csrf
  plugin :sessions, secret: SecureRandom.base64(64)
  plugin :shared_vars

  Dir["#{__dir__}/*/router.rb"].map { require it }

  route do |r|
    event_store_client = Infra::EventStoreClient.new
    request_id = request.env["HTTP_X_REQUEST_ID"] || SecureRandom.uuid

    r.public

    check_csrf!

    r.on "res" do
      require "ruby_event_store/browser/app"

      r.run RubyEventStore::Browser::App.for(event_store_locator: -> { event_store_client })
    end

    event_store_client.with_metadata(request_id: request_id, remote_ip: request.env["REMOTE_ADDR"]) do
      r.hash_branches

      r.root do
        "Wieczni Mistrzowie"
      end
    end
  end
end

run App.freeze.app

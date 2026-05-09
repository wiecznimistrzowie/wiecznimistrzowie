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
  plugin :request_headers
  plugin :route_csrf
  plugin :sessions, secret: SecureRandom.base64(64)
  plugin :shared_vars

  require_relative "cms/router"

  def config = opts[:config]

  route do |r|
    r.public

    check_csrf!

    r.get "health" do
      "OK"
    end

    r.hash_branches

    r.root do
      "Wieczni Mistrzowie"
    end
  end
end

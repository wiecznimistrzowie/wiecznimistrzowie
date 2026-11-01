# frozen_string_literal: true

require_relative "boot"
require "forwardable"

class App < Roda
  extend Forwardable
  include Dry::Monads[:result]

  def_delegators :config, :command_bus, :event_store, :query_bus, :logger

  opts[:root] = __dir__

  plugin :common_logger
  plugin :flash
  plugin :named_routes
  plugin :hash_branches
  plugin :path
  plugin :public
  plugin :request_headers
  plugin :rodauth do
    db Sequel.connect(ENV.delete("DATABASE_RODAUTH_URL"))
    enable :login, :logout
    enable :internal_request, :create_account if ENV["RACK_ENV"] == "test"
    accounts_table Sequel[:rodauth][:accounts]
    already_logged_in do
      redirect "/"
    end
    function_name do |name|
      "rodauth_password.#{name}"
    end
    password_hash_table Sequel[:rodauth_password][:account_password_hashes]
    login_label "Email"
    login_param "email"
    default_redirect "/cms"
  end
  plugin :route_csrf
  plugin :sessions, secret: ENV.delete("SESSION_SECRET") || SecureRandom.base64(64)
  plugin :shared_vars

  require_relative "cms/router"

  def config = opts[:config]

  route do |r|
    r.rodauth
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

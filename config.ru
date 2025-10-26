# frozen_string_literal: true

require_relative "boot"

class App < Roda
  route do |r|
    r.root do
      "Wieczni Mistrzowie"
    end
  end
end

run App.freeze.app

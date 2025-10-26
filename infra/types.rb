# frozen_string_literal: true

module Infra
  module Types
    extend self

    def _Uuid = _String(/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}/)
  end
end

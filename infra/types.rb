# frozen_string_literal: true

module Infra
  module Types
    extend self

    def _Uuid(ver = 4) = _String(/[0-9a-f]{8}-[0-9a-f]{4}-#{ver}[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}/)
  end
end

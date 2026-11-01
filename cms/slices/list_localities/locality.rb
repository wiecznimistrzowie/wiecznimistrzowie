# frozen_string_literal: true

module CMS::ListLocalities
  class Locality < Literal::Data
    extend Infra::Types

    prop :locality_id, _Uuid(7)
    prop :name, String
  end
end

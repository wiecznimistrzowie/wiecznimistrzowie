# frozen_string_literal: true

module CMS
  module AddingLocality
    class AddLocality < Infra::Command
      prop :locality_id, _Uuid(7), default: -> { SecureRandom.uuid_v7 }
      prop :name, String
    end
  end
end

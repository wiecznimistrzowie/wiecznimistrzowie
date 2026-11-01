# frozen_string_literal: true

module CMS
  class LocalityWasAdded < Infra::DomainEvent
    prop :locality_id, _Uuid(7)
    prop :name, String
  end
end

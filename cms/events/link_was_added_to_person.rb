# frozen_string_literal: true

module CMS
  class LinkWasAddedToPerson < Infra::DomainEvent
    prop :person_id, _Uuid(7)
    prop :url, String
    prop :label, String
  end
end

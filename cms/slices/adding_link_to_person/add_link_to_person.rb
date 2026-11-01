# frozen_string_literal: true

module CMS
  module AddingLinkToPerson
    class AddLinkToPerson < Infra::Command
      prop :person_id, _Uuid(7)
      prop :url, String
      prop :label, String
    end
  end
end

# frozen_string_literal: true

module CMS
  module AddingPerson
    class PersonWasAdded < Infra::DomainEvent
      prop :person_id, _Uuid(7)
      prop :first_name, String
      prop :last_name, String
      prop :date_of_birth, String do |value|
        value.to_s
      end
      prop :date_of_death, String do |value|
        value.to_s
      end
    end
  end
end

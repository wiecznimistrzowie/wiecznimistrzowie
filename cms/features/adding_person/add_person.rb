# frozen_string_literal: true

module CMS
  module AddingPerson
    class AddPerson < Infra::Command
      prop :person_id, _Uuid(7), default: -> { SecureRandom.uuid_v7 }
      prop :first_name, String
      prop :last_name, String
      prop :date_of_birth, Date do |value|
        Date.strptime(value, "%Y-%m-%d")
      end
      prop :date_of_death, Date do |value|
        Date.strptime(value, "%Y-%m-%d")
      end
    end
  end
end

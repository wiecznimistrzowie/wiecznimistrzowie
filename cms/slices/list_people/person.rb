# frozen_string_literal: true

module CMS::ListPeople
  class Person < Literal::Data
    extend Infra::Types

    prop :person_id, _Uuid(7)
    prop :first_name, String
    prop :last_name, String
    prop :date_of_birth, String
    prop :date_of_death, String

    def full_name
      "#{first_name} #{last_name}"
    end
  end
end

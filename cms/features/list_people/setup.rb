# frozen_string_literal: true

module CMS
  module ListPeople
    module Setup
      subscription = Infra::Catchup.new(
        materialized_view: Infra::MaterializedView.new(
          state_repository: StateRepository.new,
          view: ReadModel
        ),
        event_types: [AddingPerson::PersonWasAdded]
      )

      Infra::Config.query_bus.register(
        ByName,
        ->(_) {
          subscription.call

          Infra::Config.db[:cms_people].order(:last_name, :first_name).map do |data|
            Person.new(
              person_id: data[:person_id],
              first_name: data[:first_name],
              last_name: data[:last_name],
              date_of_birth: data[:date_of_birth].strftime("%Y-%m-%d"),
              date_of_death: data[:date_of_death].strftime("%Y-%m-%d")
            )
          end
        }
      )
    end
  end
end

# frozen_string_literal: true

module CMS
  module ListLocalities
    module Setup
      subscription = Infra::Catchup.new(
        materialized_view: Infra::MaterializedView.new(
          state_repository: StateRepository.new,
          view: ReadModel
        ),
        event_types: [LocalityWasAdded]
      )

      Infra::Config.query_bus.register(
        ByName,
        ->(_) {
          subscription.call

          Infra::Config.db[:cms_localities].order(:name, :id).map do |data|
            Locality.new(
              locality_id: data[:locality_id],
              name: data[:name]
            )
          end
        }
      )
    end
  end
end

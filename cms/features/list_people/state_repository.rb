# frozen_strling_literal: true

module CMS::ListPeople
  class StateRepository
    def initialize
      @db = Infra::Config.db[:cms_people]
    end

    def fetch_state(event)
      @db.where(person_id: event.person_id).first
    end

    def current_position
      @db.max(:last_position) || 0
    end

    def save(state, position)
      @db.insert_conflict(
        target: :person_id,
        update: state.to_h.each_with_object({}) { |(k, _), h| h[k] = Sequel[:excluded][k] },
        update_where: Sequel[:excluded][:last_position] > Sequel[:cms_people][:last_position]
      ).insert(
        last_position: position,
        person_id: state.person_id,
        first_name: state.first_name,
        last_name: state.last_name,
        date_of_birth: state.date_of_birth,
        date_of_death: state.date_of_death,
        created_at: Time.now,
        updated_at: Time.now
      )
    end
  end
end
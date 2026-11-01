# frozen_string_literal: true

module CMS::ListLocalities
  class StateRepository
    def initialize
      @db = Infra::Config.db[:cms_localities]
    end

    def fetch_state(event)
      @db.where(locality_id: event.locality_id).first
    end

    def current_position
      @db.max(:last_position) || 0
    end

    def save(state, position)
      @db.insert_conflict(
        target: :locality_id,
        update: {name: Sequel[:excluded][:name], last_position: Sequel[:excluded][:last_position], updated_at: Sequel[:excluded][:updated_at]},
        update_where: Sequel[:excluded][:last_position] > Sequel[:cms_localities][:last_position]
      ).insert(
        last_position: position,
        locality_id: state.locality_id,
        name: state.name,
        created_at: Time.now,
        updated_at: Time.now
      )
    end
  end
end

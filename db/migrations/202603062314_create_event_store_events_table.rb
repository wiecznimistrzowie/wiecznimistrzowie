# frozen_string_literal: true

::Sequel.migration do
  up do
    create_table :events do
      primary_key :sequence, type: :Bignum, null: false

      column :event_id, String, null: false
      column :event_type, String, null: false
      column :tags, :jsonb, null: false, default: "{}"
      column :metadata, :jsonb, null: false, default: "{}"
      column :data, :jsonb, null: false
      column :created_at, :timestamp, null: false

      index :event_id, unique: true, name: "index_events_on_event_id"
    end
  end

  down do
    drop_table :events
  end
end

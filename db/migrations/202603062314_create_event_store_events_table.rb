# frozen_string_literal: true

::Sequel.migration do
  up do
    create_table :events do
      primary_key :sequence, type: :Bignum, null: false

      column :event_id, :uuid, null: false
      column :event_type, String, null: false
      column :metadata, :jsonb, null: false, default: "{}"
      column :data, :jsonb, null: false
      column :occurred_at, :timestamp, null: false, default: Sequel.function(:now)

      index :event_id, unique: true, name: "index_events_on_event_id"
      index :event_type, name: "index_events_on_event_type"
      index :data, opclass: :jsonb_path_ops, name: "index_events_on_data", type: :gin
    end
  end

  down do
    drop_table :events
  end
end

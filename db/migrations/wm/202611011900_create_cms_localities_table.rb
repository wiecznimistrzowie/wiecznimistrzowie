# frozen_string_literal: true

::Sequel.migration do
  up do
    create_table :cms_localities do
      primary_key :id, type: :Bignum, null: false
      column :last_position, :Bignum, null: false

      column :locality_id, :uuid, null: false
      column :name, String, null: false

      column :created_at, :timestamp, null: false
      column :updated_at, :timestamp, null: false

      index :locality_id, unique: true, name: "idx_cms_localities_on_locality_id"
      index :name, name: "idx_cms_localities_on_name"
    end
  end

  down do
    drop_table :cms_localities
  end
end

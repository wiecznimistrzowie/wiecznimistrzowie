# frozen_string_literal: true

::Sequel.migration do
  up do
    create_table :cms_people do
      primary_key :id, type: :Bignum, null: false

      column :person_id, :uuid, null: false
      column :first_name, String, null: false
      column :last_name, String, null: false
      column :date_of_birth, Date, null: false
      column :date_of_death, Date, null: false

      column :created_at, :timestamp, null: false
      column :updated_at, :timestamp, null: false

      index :person_id, unique: true, name: "idx_cms_people_on_person_id"
    end
  end

  down do
    drop_table :cms_people
  end
end

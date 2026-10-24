# frozen_string_literal: true

::Sequel.migration do
  up do
    run "CREATE SCHEMA AUTHORIZATION wm"
    run "CREATE SCHEMA AUTHORIZATION rodauth"
    run "CREATE SCHEMA AUTHORIZATION rodauth_password"
    run "DO $$ BEGIN EXECUTE format('GRANT CREATE ON DATABASE %I TO wm', current_database()); END $$;"
    run "GRANT CREATE ON SCHEMA public TO wm"
    run "GRANT USAGE ON SCHEMA rodauth TO rodauth_password"
    run "GRANT USAGE ON SCHEMA rodauth_password TO rodauth"
    run "CREATE EXTENSION citext SCHEMA rodauth"
  end
end

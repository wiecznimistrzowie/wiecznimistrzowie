# frozen_string_literal: true

::Sequel.migration do
  up do
    run "CREATE SCHEMA AUTHORIZATION wm"
    run "CREATE SCHEMA AUTHORIZATION rodauth"
    run "CREATE SCHEMA AUTHORIZATION rodauth_password"
    run "GRANT USAGE ON SCHEMA rodauth TO rodauth_password"
    run "GRANT USAGE ON SCHEMA rodauth_password TO rodauth"
    run "CREATE EXTENSION citext SCHEMA rodauth"
  end
end

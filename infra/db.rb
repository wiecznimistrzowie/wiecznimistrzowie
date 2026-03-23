# frozen_string_literal

module Infra
  DB = Sequel.connect(ENV.delete("DATABASE_URL"))

  DB.extension(:pg_json, :pg_array)
  Sequel.extension(:pg_json_ops, :pg_array_ops)
end


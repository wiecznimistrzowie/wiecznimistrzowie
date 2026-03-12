# frozen_string_literal

module Infra
  DB = Sequel.connect(ENV.delete("DATABASE_URL"))

  DB.extension(:pg_json)
  Sequel.extension(:pg_json_ops)
end


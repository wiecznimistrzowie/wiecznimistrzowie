# frozen_string_literal

module Infra
  DB = Sequel.connect(ENV.delete("DATABASE_URL"))
end

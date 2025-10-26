# frozen_string_literal: true

module Infra
  Loader = Zeitwerk::Loader.new.tap do |loader|
    loader.push_dir(__dir__, namespace: Infra)

    loader.inflector.inflect(
      "db" => "DB"
    )

    loader.setup
  end
end

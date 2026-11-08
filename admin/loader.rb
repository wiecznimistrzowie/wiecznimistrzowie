# frozen_string_literal: true

module Admin
  Loader = Zeitwerk::Loader.new.tap do |loader|
    loader.push_dir(__dir__, namespace: Admin)

    loader.setup
  end
end

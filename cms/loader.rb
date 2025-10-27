# frozen_string_literal: true

module CMS
  Loader = Zeitwerk::Loader.new.tap do |loader|
    loader.push_dir(__dir__, namespace: CMS)

    tests = "#{__dir__}/**/test_*.rb"
    loader.ignore(tests)

    loader.ignore("#{__dir__}/router.rb")

    loader.collapse("#{__dir__}/features")

    loader.setup
  end
end

# frozen_string_literal: true

class App
  slices = Dir["#{__dir__}/slices/**/endpoint.rb"].map { |file|
    require file

    Pathname.new(file).dirname.basename.to_s
  }

  hash_branch :admin, "cms" do |r|
    slices.each { r.route(it) }

    "cms"
  end
end

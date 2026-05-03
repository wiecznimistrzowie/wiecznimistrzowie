# frozen_string_literal: true

class App
  slices = Dir["#{__dir__}/features/**/endpoint.rb"].map { |file|
    require file

    Pathname.new(file).dirname.basename.to_s
  }

  hash_branch "cms" do |r|
    if r.headers["HX-Request"]
      slices.each { r.route(it) }
    else
      CMS::Layout.new(current_path: r.path).call
    end
  end
end

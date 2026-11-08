# frozen_string_literal: true

class App
  slices = Dir["#{__dir__}/slices/**/endpoint.rb"].map { |file|
    require file

    Pathname.new(file).dirname.basename.to_s
  }

  hash_branch :admin, "cms" do |r|
    if r.headers["HX-Request"]
      slices.each { r.route(it) }

      "cms"
    else
      account = Account.from_rodauth(rodauth.account!)

      CMS::Layout.new(app: self, account: account, current_path: r.path).call
    end
  end
end

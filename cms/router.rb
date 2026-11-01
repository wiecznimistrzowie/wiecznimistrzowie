# frozen_string_literal: true

Account = Data.define(:id, :email) do
  def self.from_rodauth(account)
    new(id: account[:id], email: account[:email])
  end
end

class App
  slices = Dir["#{__dir__}/slices/**/endpoint.rb"].map { |file|
    require file

    Pathname.new(file).dirname.basename.to_s
  }

  hash_branch "cms" do |r|
    rodauth.require_authentication

    if r.headers["HX-Request"]
      slices.each { r.route(it) }

      "TODO"
    else
      account = Account.from_rodauth(rodauth.account!)

      CMS::Layout.new(app: self, account: account, current_path: r.path).call
    end
  end
end

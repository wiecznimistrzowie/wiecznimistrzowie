# frozen_string_literal: true

class App
  hash_branch "admin" do |r|
    rodauth.require_authentication

    if r.headers["HX-Request"]
      r.hash_branches(:admin)

      "admin root"
    else
      account = Admin::Account.from_rodauth(rodauth.account!)

      Admin::Layout.new(app: self, account: account, current_path: r.path).call
    end
  end
end

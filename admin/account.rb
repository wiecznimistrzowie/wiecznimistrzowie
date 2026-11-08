# frozen_string_literal: true

module Admin
  Account = Data.define(:id, :email) do
    def self.from_rodauth(account)
      new(id: account[:id], email: account[:email])
    end
  end
end
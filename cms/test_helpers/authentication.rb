# frozen_string_literal: true

module CMS
  module TestHelpers
    module Authentication
      ADMIN_EMAIL = "admin@example.com"

      def sign_in_admin
        ensure_admin
        sign_in(email: ADMIN_EMAIL, password: "password")
      end

      def ensure_admin
        admin = App.rodauth.account_exists?(login: ADMIN_EMAIL)
        admin or create_account(email: ADMIN_EMAIL, password: "password")
      end

      def create_account(email:, password:)
        App.rodauth.create_account(
          login: email,
          password: password
        )
      end

      def sign_in(email:, password: "password")
        visit("/login")
        fill_in("Email", with: email)
        fill_in("Password", with: password)
        click_button("Login")
      end
    end
  end
end
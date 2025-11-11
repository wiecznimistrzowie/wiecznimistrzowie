# frozen_string_literal: true

module Infra
  class HtmlComponent < Phlex::HTML
    extend Literal::Properties

    prop :app, _Nilable(App)

    private

    def csrf_token(path)
      raise "App not provided" unless @app

      @app.csrf_token(path)
    end
  end
end

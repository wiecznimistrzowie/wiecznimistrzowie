# frozen_string_literal: true

module CMS::Components
  class Link < Infra::HtmlComponent
    prop :href, String

    def view_template(&)
      a(href: @href, hx_get: @href, hx_target: "main", hx_push_url: "true", &)
    end
  end
end

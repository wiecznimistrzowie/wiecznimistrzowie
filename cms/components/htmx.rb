# frozen_string_literal: true

module CMS::Components
  class HTMX < Infra::HtmlComponent
    prop :src, String, default: "https://cdn.jsdelivr.net/npm/htmx.org@2.0.8/dist/htmx.min.js"
    prop :integrity, String, default: "sha384-/TgkGk7p307TH7EXJDuUlgG3Ce1UVolAOFopFekQkkXihi5u/6OCvVKyz1W+idaz"

    def view_template
      script(src: @src, integrity: @integrity, crossorigin: "anonymous")
    end
  end
end

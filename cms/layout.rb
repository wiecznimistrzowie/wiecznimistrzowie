# frozen_string_literal: true

module CMS
  class Layout < HtmlView
    SCRIPTS = {
      "https://cdn.jsdelivr.net/npm/htmx.org@2.0.8/dist/htmx.min.js" => "sha384-/TgkGk7p307TH7EXJDuUlgG3Ce1UVolAOFopFekQkkXihi5u/6OCvVKyz1W+idaz"
    }

    prop :current_path, String

    def view_template
      doctype
      html(lang: "en") do
        head do
          meta(charset: "utf-8")
          meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
          meta(name: "description", content: "")

          title { "Loading..." }
        end
        body do
          header do
            nav do
              Link(href: "/cms/people") { "People" }
            end
          end

          main do
            p(hx_get: @current_path, hx_trigger: "load", hx_target: "main") { "Loading..." }
          end

          footer do
            p { "Wieczni Mistrzowie (c) 2026" }
          end

          SCRIPTS.each do |src, integrity|
            script(src: src, integrity: integrity, crossorigin: "anonymous")
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module CMS
  class Layout < HtmlView
    prop :title, String, default: "Wieczni Mistrzowie"

    def view_template
      doctype
      html(lang: "en") do
        head do
          meta(charset: "utf-8")
          meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
          meta(name: "description", content: "")

          title { @title }
        end
        body do
          header do
            nav do
              Link(href: "/cms/people") { "People" }
            end
          end

          main do
            p(hx_get: "/cms/people", hx_trigger: "load", hx_target: "main") { "Loading..." }
          end

          footer do
            p { "Wieczni Mistrzowie (c) 2026" }
          end

          HTMX()
        end
      end
    end
  end
end

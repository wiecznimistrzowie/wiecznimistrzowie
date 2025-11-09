# frozen_string_literal: true

module CMS::Components
  class Layout < Phlex::HTML
    extend Literal::Properties

    prop :title, String, default: "Wieczni Mistrzowie"
    prop :content, _Union(_Class(Phlex::HTML), _Constraint(Phlex::HTML))

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
              a(href: "/cms/people") { "People" }
            end
          end

          main { render @content }

          footer do
            p { "Wieczni Mistrzowie (c) 2025" }
          end
        end
      end
    end
  end
end

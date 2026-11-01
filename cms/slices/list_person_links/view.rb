# frozen_string_literal: true

module CMS
  module ListPersonLinks
    class View < HtmlView
      prop :links, Array

      def view_template
        h2 { "Links" }
        table(data_testid: "links-list") do
          thead do
            tr do
              th { "Label" }
              th { "URL" }
            end
          end
          tbody do
            @links.each do |link|
              tr do
                td(data_testid: "link-label") { link.label }
                td do
                  a(href: link.url, data_testid: "link-url") { link.url }
                end
              end
            end
          end
        end
      end
    end
  end
end

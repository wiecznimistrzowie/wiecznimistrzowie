# frozen_string_literal: true

module CMS
  module ListLocalities
    class View < HtmlView
      prop :localities, Array

      def view_template
        HtmxTitle { "Localities" }
        h1 { "List of Localities" }
        a(href: "/admin/cms/localities/add") { "Add New Locality" }
        table(data_testid: "localities-list") do
          thead do
            tr do
              th { "Name" }
              th {}
            end
          end
          tbody do
            @localities.each do |locality|
              tr do
                td(data_testid: "locality-name") { locality.name }
                td do
                  a(href: "/admin/cms/localities/#{locality.locality_id}") { "Show" }
                end
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module CMS
  module ShowLocality
    class View < HtmlView
      prop :locality, Locality

      def view_template
        HtmxTitle { @locality.name }
        table do
          tr do
            td { "UUID" }
            td { @locality.locality_id }
          end
          tr do
            td { "Name:" }
            td { @locality.name }
          end
        end
      end
    end
  end
end

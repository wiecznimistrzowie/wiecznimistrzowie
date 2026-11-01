# frozen_string_literal: true

module CMS
  module AddingLocality
    class View < HtmlView
      prop :form_data, Hash, default: {}.freeze

      def view_template
        HtmxTitle { "Add locality" }
        Form("/cms/localities/add", app: @app, form_data: @form_data, testid: "adding-locality") do |f|
          fieldset do
            legend { "Locality details" }

            f.input_block!(label: "Name", name: "name")
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module CMS
  module AddingLinkToPerson
    class View < HtmlView
      prop :person_id, String
      prop :form_data, Hash, default: {}.freeze

      def view_template
        HtmxTitle { "Add link" }
        Form("/cms/people/#{@person_id}/links/add", app: @app, form_data: @form_data, testid: "adding-link-to-person") do |f|
          fieldset do
            legend { "Link details" }

            f.input_block!(label: "URL", name: "url", type: :url)
            f.input_block!(label: "Label", name: "label")
          end
        end
      end
    end
  end
end

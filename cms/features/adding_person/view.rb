# frozen_string_literal: true

module CMS
  module AddingPerson
    class View < HtmlView
      prop :form_data, Hash, default: {}.freeze

      def view_template
        Form("/cms/people/add", app: @app, form_data: @form_data) do |f|
          fieldset do
            legend { "Person details" }

            f.input_block!(label: "First name", name: "first_name")
            f.input_block!(label: "Last name", name: "last_name")
            f.input_block!(label: "Date of birth", name: "date_of_birth", type: :date)
            f.input_block!(label: "Date of death", name: "date_of_death", type: :date)
          end
        end
      end
    end
  end
end

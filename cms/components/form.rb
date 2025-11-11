# frozen_string_literal: true

module CMS::Components
  class Form < Infra::HtmlComponent
    prop :action, String, :positional
    prop :form_data, Hash, default: {}.freeze
    prop :errors, Hash, default: {}.freeze

    def view_template
      form(action: @action, method: "POST") do
        input(type: :hidden, name: "_csrf", value: csrf_token(@action))

        yield

        fieldset do
          button(type: :submit) { "Save" }
        end
      end
    end

    def input_block(label:, name:, type: :text)
      Input(
        label: label,
        name: name,
        value: @form_data[name],
        required: false,
        type: type
      )
    end

    def input_block!(label:, name:, type: :text)
      Input(
        label: label,
        name: name,
        value: @form_data[name],
        required: true,
        type: type
      )
    end
  end
end

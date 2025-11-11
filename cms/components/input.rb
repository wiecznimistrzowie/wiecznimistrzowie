# frozen_string_literal: true

module CMS::Components
  class Input < Infra::HtmlComponent
    prop :label, String
    prop :name, String
    prop :value, _Nilable(String)
    prop :type, Symbol, default: :text
    prop :required, _Boolean, default: false

    def view_template
      div do
        label(for: @name) { @label }
        input(
          type: @type,
          name: @name,
          id: @name,
          required: @required,
          value: @value
        )
      end
    end
  end
end

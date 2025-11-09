# frozen_string_literal: true

module CMS
  module Components
    class Input < Phlex::HTML
      extend Literal::Properties

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
end

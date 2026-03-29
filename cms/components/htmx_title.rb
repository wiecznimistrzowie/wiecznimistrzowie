# frozen_string_literal: true

module CMS::Components
  class HtmxTitle < Infra::HtmlComponent
    def view_template(&)
      title(hx_swap_oob: "true", &)
    end
  end
end

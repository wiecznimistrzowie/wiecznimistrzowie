# frozen_string_literal: true

module CMS
  class HtmlView < Phlex::HTML
    include Components
    extend Literal::Properties
  end
end

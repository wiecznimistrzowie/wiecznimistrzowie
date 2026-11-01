# frozen_string_literal: true

module CMS::ListPersonLinks
  class Link < Literal::Data
    prop :url, String
    prop :label, String
  end
end

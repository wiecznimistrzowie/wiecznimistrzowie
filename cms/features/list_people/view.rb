# frozen_string_literal: true

module CMS
  module ListPeople
    class View < Phlex::HTML
      def view_template
        h1 { "List of People" }
        a(href: "/cms/people/add") { "Add New Person" }
      end
    end
  end
end

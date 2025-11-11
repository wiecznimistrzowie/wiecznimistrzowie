# frozen_string_literal: true

module CMS
  module ShowPerson
    class View < HtmlView
      prop :person, Person

      def view_template
        table do
          tr do
            td { "UUID" }
            td { @person.person_id }
          end
          tr do
            td { "First name:" }
            td { @person.first_name }
          end
          tr do
            td { "Last name:" }
            td { @person.last_name }
          end
          tr do
            td { "Date of birth:" }
            td { @person.date_of_birth.strftime("%Y-%m-%d") }
          end
          tr do
            td { "Date of death:" }
            td { @person.date_of_death.strftime("%Y-%m-%d") }
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module CMS
  module ListPeople
    class View < HtmlView
      prop :people, Sequel::Postgres::Dataset

      def view_template
        h1 { "List of People" }
        a(href: "/cms/people/add") { "Add New Person" }
        table do
          thead do
            tr do
              th { "Last Name" }
              th { "First Name" }
              th { "Date of Birth" }
              th { "Date of Death" }
              th { "Added at" }
              th {}
            end
          end
          tbody do
            @people.each do |person|
              tr do
                td { person[:last_name] }
                td { person[:first_name] }
                td { person[:date_of_birth].strftime("%Y-%m-%d") }
                td { person[:date_of_death].strftime("%Y-%m-%d") }
                td { person[:created_at].localtime.strftime("%Y-%m-%d %H:%M:%S") }
                td do
                  a(href: "/cms/people/#{person[:person_id]}") { "Show" }
                end
              end
            end
          end
        end
      end
    end
  end
end

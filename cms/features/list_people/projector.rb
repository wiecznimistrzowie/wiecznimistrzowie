# frozen_string_literal: true

module CMS
  module ListPeople
    class Projector
      def initialize(db:)
        @db = db
      end

      def call(event)
        case event
        in {event_type: "CMS::AddingPerson::PersonWasAdded", data:, metadata:}
          @db[:cms_people].insert(
            **data.slice(:person_id, :first_name, :last_name, :date_of_birth, :date_of_death),
            created_at: metadata[:timestamp],
            updated_at: metadata[:timestamp]
          )
        end
      end
    end
  end
end

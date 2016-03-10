class EventsGenre < ActiveRecord::Base
    # Activemodel Associations
    belongs_to :event
    belongs_to :genre, :foreign_key => "genre_name"
end

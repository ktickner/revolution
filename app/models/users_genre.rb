class UsersGenre < ActiveRecord::Base
    # Activemodel Associations
    belongs_to :user
    belongs_to :genre, :foreign_key => "genre_name"
end

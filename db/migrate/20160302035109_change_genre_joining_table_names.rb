class ChangeGenreJoiningTableNames < ActiveRecord::Migration
  def change
    rename_table :user_genres, :users_genres
    rename_table :event_genres, :events_genres
  end
end

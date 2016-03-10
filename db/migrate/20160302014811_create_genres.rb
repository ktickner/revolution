class CreateGenres < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE genres(
        name varchar(50) PRIMARY KEY
          check (length(name) > 0),
        creator_id int4 REFERENCES users(id) ON DELETE RESTRICT
      );
      
      CREATE TABLE user_genres(
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        genre_name varchar(50) REFERENCES genres(name) ON DELETE RESTRICT,
        PRIMARY KEY (user_id, genre_name)
      );
      
      CREATE TABLE event_genres(
        event_id int4 REFERENCES events(id) ON DELETE RESTRICT,
        genre_name varchar(50) REFERENCES genres(name) ON DELETE RESTRICT,
        PRIMARY KEY (event_id, genre_name)
      );
    SQL
    
    add_column :genres, :created_at, :datetime, :null => false
    add_column :genres, :updated_at, :datetime, :null => false
    
    add_column :user_genres, :created_at, :datetime, :null => false
    add_column :user_genres, :updated_at, :datetime, :null => false
    
    add_column :event_genres, :created_at, :datetime, :null => false
    add_column :event_genres, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :genres
    drop_table :user_genres
    drop_table :event_genres
  end
end

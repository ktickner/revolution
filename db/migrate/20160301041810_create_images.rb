class CreateImages < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE images (
        id serial4 PRIMARY KEY,
        creator_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        path varchar(255) NOT NULL
          check (length(path) > 0),
        removed boolean NOT NULL DEFAULT FALSE
      );
    SQL
      
      
    add_column :images, :created_at, :datetime, :null => false
    add_column :images, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :images
  end
end

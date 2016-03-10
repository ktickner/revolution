class CreateJoinTable < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE events_images(
        event_id int4 REFERENCES events(id) ON DELETE RESTRICT,
        image_id int4 REFERENCES images(id) ON DELETE RESTRICT,
        feature_image boolean NOT NULL DEFAULT FALSE
        );
    SQL
    
    add_column :events_images, :created_at, :datetime, :null => false
    add_column :events_images, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :events_images
  end
end

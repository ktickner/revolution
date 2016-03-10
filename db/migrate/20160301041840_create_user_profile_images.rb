class CreateUserProfileImages < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE user_profile_images (
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        image_id int4 REFERENCES images(id) ON DELETE RESTRICT,
        current_profile_image boolean NOT NULL,
        PRIMARY KEY (user_id, image_id)
      );
    SQL
      
      
    add_column :user_profile_images, :created_at, :datetime, :null => false
    add_column :user_profile_images, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :user_profile_images
  end
end

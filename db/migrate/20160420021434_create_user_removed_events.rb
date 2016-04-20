class CreateUserRemovedEvents < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE user_removed_events (
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        event_id int4 REFERENCES events(id) ON DELETE RESTRICT,
        removed boolean NOT NULL,
        PRIMARY KEY (user_id, event_id)
      );
    SQL
      
      
    add_column :user_removed_events, :created_at, :datetime, :null => false
    add_column :user_removed_events, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :user_removed_events
  end
end

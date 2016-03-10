class CreateFriendConnections < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE friend_connections (
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        friend_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        PRIMARY KEY (user_id, friend_id)
      );
    SQL
    
    add_column :friend_connections, :created_at, :datetime, :null => false
    add_column :friend_connections, :updated_at, :datetime, :null => false
    
  end
  
  def down
    drop_table :friend_connections
  end
end

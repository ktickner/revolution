class CreateUserLogs < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE user_logs (
        id serial4 PRIMARY KEY,
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        description text NOT NULL
          check (length(description) > 0)
      );
    SQL
    
    add_column :user_logs, :created_at, :datetime, :null => false
    add_column :user_logs, :updated_at, :datetime, :null => false
    
  end
  
  def down
    drop_table :user_logs
  end
end

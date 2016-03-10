class CreateEventLogs < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE event_logs (
        id serial4 PRIMARY KEY,
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        event_id int4 REFERENCES events(id) ON DELETE RESTRICT,
        description text NOT NULL
          check (length(description) > 0)
      );
    SQL
    
    add_column :event_logs, :created_at, :datetime, :null => false
    add_column :event_logs, :updated_at, :datetime, :null => false    
  end
  
  def down
    drop_table :event_logs
  end
end

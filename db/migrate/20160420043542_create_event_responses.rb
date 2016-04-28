class CreateEventResponses < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE event_responses(
        response varchar(50) PRIMARY KEY
          check (length(response) > 0)
      );
    SQL

    add_column :event_responses, :created_at, :datetime, :null => false
    add_column :event_responses, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :event_responses
  end
end

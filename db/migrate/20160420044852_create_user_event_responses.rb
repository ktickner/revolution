class CreateUserEventResponses < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE user_event_responses (
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        event_id int4 REFERENCES events(id) ON DELETE RESTRICT,
        response_id varchar(50) REFERENCES event_responses(response) ON DELETE RESTRICT,
        PRIMARY KEY (user_id, event_id)
      );
    SQL
      
      
    add_column :user_event_responses, :created_at, :datetime, :null => false
    add_column :user_event_responses, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :user_event_responses
  end
end

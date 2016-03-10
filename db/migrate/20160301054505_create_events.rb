class CreateEvents < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE events (
        id serial4 PRIMARY KEY,
        creator_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        location_id int4 REFERENCES locations(id) ON DELETE RESTRICT,
        name varchar(255) NOT NULL
          check (length(name) > 0),
        description text NOT NULL
          check (length(description) > 0),
        over_eighteen boolean NOT NULL DEFAULT FALSE,
        private boolean NOT NULL DEFAULT FALSE,
        cancelled boolean NOT NULL DEFAULT FALSE,
        start_datetime timestamptz NOT NULL,
        end_datetime timestamptz
          check (end_datetime > start_datetime)
      );
    SQL


    add_column :events, :created_at, :datetime, :null => false
    add_column :events, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :events
  end
end

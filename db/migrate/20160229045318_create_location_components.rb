class CreateLocationComponents < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE location_components (
        id serial4 PRIMARY KEY,
        location_id int4 REFERENCES locations(id) ON DELETE RESTRICT,
        component_type varchar(50) NOT NULL
          check (length(component_type) > 0 AND length(component_type) < 51),
        value varchar(100) NOT NULL
          check (length(value) > 0 AND length(value) < 101)
      );
    SQL
    
    add_column :location_components, :created_at, :datetime, :null => false
    add_column :location_components, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :location_components
  end
end

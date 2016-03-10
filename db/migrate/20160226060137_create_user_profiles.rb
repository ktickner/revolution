class CreateUserProfiles < ActiveRecord::Migration
  def up
    
    execute <<-SQL
      CREATE TABLE user_profiles (
        user_id int4 REFERENCES users(id) ON DELETE RESTRICT,
        location_id int4 REFERENCES locations(id) ON DELETE RESTRICT,
        first_name varchar(255) NOT NULL
          check (length(first_name) > 0),
        last_name varchar(255) NOT NULL
          check (length(last_name) > 0),
        birth_date timestamp NOT NULL
          check (birth_date > '1900-01-01 00:00:01'),
        active boolean NOT NULL DEFAULT TRUE,
        PRIMARY KEY (user_id)
      );
    SQL

    add_column :user_profiles, :created_at, :datetime, :null => false
    add_column :user_profiles, :updated_at, :datetime, :null => false
  end
  
  def down
    drop_table :user_profiles
  end
end

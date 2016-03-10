class AddLatAndLngToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :lat, :decimal, :precision => 10, :scale => 8, :null => false
    add_column :locations, :lng, :decimal, :precision => 11, :scale => 8, :null => false
    
    add_index :locations, [:lat, :lng], :unique => true
  end
end

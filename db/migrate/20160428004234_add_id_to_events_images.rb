class AddIdToEventsImages < ActiveRecord::Migration
  def change
    add_column :events_images, :id, :primary_key
  end
end

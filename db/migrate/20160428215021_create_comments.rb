class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :creator, index: true
      t.references :event, index: true
      t.string :comment
      t.timestamps null: false
    end
    add_foreign_key :comments, :users, column: :creator_id
    add_foreign_key :comments, :events
  end
end

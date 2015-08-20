class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, null: false, limit: 32
      t.string :map_id, null: false, limit: 32, unique: true
      t.boolean :occupied, null: false

      t.timestamps null: false
    end
  end
end

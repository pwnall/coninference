class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.references :map, null: false, index: true
      t.string :name, null: false, limit: 32
      t.string :dom_selector, null: false, limit: 32, index: { unique: true }
      t.boolean :occupied, null: false
    end
  end
end

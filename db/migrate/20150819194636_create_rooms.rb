class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.references :map, null: false, index: true
      t.string :url_name, limit: 32, null: false, index: { unique: true }
      t.string :name, null: false, limit: 32
      t.string :dom_selector, null: false, limit: 32, index: { unique: true }
      t.boolean :occupied, null: false
      t.string :key, null: false, limit: 64, index: { unique: true }
      t.string :push_url, null: true, limit: 256

      t.index [:map_id, :name], unique: true
    end
  end
end

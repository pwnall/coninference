class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name, limit: 64, null: false, index: { unique: true }
      t.string :url_name, limit: 32, null: false, index: { unique: true }
      t.string :key, null: false, limit: 64, index: { unique: true }
      t.string :push_url, null: true, limit: 256
    end
  end
end

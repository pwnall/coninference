class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :bar, index: true, null: true
      t.string :name, null: true, limit: 64
      t.string :url_name, limit: 32, null: false, index: { unique: true }
      t.string :key, null: false, limit: 64, index: { unique: true }
      t.string :push_url, null: true, limit: 256
      t.string :node_version, null: true, limit: 32
      t.string :serial, null: true, limit: 64
    end
  end
end

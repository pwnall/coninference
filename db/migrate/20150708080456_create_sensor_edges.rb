class CreateSensorEdges < ActiveRecord::Migration
  def change
    create_table :sensor_edges do |t|
      t.references :device, null: false, foreign_key: true
      t.string :kind, null: false, limit: 16
      t.float :value, null: false

      t.datetime :created_at, null: false
      t.datetime :device_time, null: false

      t.index [:device_id, :kind, :created_at]
    end
  end
end

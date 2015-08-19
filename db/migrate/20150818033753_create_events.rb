class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :url_name, limit: 32, null: false, index: { unique: true }
      t.references :user, null: false

      t.string :label, limit: 128, null: false
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: true

      t.index [:user_id, :started_at]
    end
  end
end

class AddFlagsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :admin, null: false
      t.string :key, null: false, limit: 64, index: { unique: true }
      t.string :push_url, null: true, limit: 256
    end
  end
end

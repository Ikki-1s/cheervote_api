class CreateHcConstituencies < ActiveRecord::Migration[6.1]
  def change
    create_table :hc_constituencies do |t|
      t.string  :name, null: false
      t.integer :quota, null: false
      t.timestamps
    end
  end
end

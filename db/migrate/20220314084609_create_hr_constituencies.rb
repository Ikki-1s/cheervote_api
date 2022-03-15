class CreateHrConstituencies < ActiveRecord::Migration[6.1]
  def change
    create_table :hr_constituencies do |t|
      t.string :name, null: false
      t.text :constituent_region
      t.references :prefecture, foreign_key: true, null: false
      t.timestamps
    end
  end
end

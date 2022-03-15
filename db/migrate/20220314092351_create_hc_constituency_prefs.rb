class CreateHcConstituencyPrefs < ActiveRecord::Migration[6.1]
  def change
    create_table :hc_constituency_prefs do |t|
      t.references :hc_constituency, foreign_key: true, null: false
      t.references :prefecture, foreign_key: true, null: false
      t.timestamps
    end
  end
end

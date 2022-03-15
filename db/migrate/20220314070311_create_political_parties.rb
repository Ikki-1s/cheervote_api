class CreatePoliticalParties < ActiveRecord::Migration[6.1]
  def change
    create_table :political_parties do |t|
      t.string :name_kanji, null: false
      t.string :name_kana, null: false
      t.string :abbreviation_kanji
      t.string :abbreviation_kana
      t.timestamps
    end
  end
end

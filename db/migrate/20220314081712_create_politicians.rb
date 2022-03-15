class CreatePoliticians < ActiveRecord::Migration[6.1]
  def change
    create_table :politicians do |t|
      t.string :last_name_kanji, limit: 5, null: false
      t.string :first_name_kanji, limit: 10, null: false
      t.string :last_name_kana, limit: 8, null: false
      t.string :first_name_kana, limit: 20, null: false
      t.text   :career
      t.string :website
      t.string :twitter
      t.string :youtube
      t.string :facebook
      t.string :other_sns
      t.timestamps
    end
  end
end

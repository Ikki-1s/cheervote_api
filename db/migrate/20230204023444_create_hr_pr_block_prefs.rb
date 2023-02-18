class CreateHrPrBlockPrefs < ActiveRecord::Migration[6.1]
  def change
    create_table :hr_pr_block_prefs do |t|
      t.references :hr_pr_block, foreign_key: true, null: false
      t.references :prefecture, foreign_key: true, null: false
      t.timestamps
    end
  end
end

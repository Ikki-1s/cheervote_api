class CreateHrPrBlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :hr_pr_blocks do |t|
      t.string :block_name, null: false
      t.integer :quota, null: false
      t.timestamps
    end
  end
end

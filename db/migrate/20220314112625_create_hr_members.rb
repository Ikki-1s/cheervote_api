class CreateHrMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :hr_members do |t|
      t.references :politician, foreign_key: true, null: false
      t.references :political_party, foreign_key: true
      t.references :hr_election_time, foreign_key: true, null: false
      t.integer    :elected_system, null: false
      t.references :hr_constituency, foreign_key: true
      t.references :hr_pr_block, foreign_key: true
      t.timestamps
    end
  end
end

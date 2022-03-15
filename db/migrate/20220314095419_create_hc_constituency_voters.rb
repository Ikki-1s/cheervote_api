class CreateHcConstituencyVoters < ActiveRecord::Migration[6.1]
  def change
    create_table :hc_constituency_voters do |t|
      t.references :hc_constituency, foreign_key: true, null: false
      t.integer :number_of_voter, null: false
      t.date :registration_date, null: false
      t.timestamps
    end
  end
end

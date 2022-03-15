class CreatePoliticalPartyMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :political_party_members do |t|
      t.references :politician, foreign_key: true, null: false
      t.references :political_party, foreign_key: true, null: false
      t.date :start_belonging_date
      t.date :end_belonging_date
      t.timestamps
    end
  end
end

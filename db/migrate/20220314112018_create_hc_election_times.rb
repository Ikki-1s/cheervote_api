class CreateHcElectionTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :hc_election_times do |t|
      t.integer :election_times, null: false
      t.date :announcement_date
      t.date :election_date
      t.date :expiration_date
      t.timestamps
    end
  end
end

class AddDissolutionDateToHrElectionTime < ActiveRecord::Migration[6.1]
  def change
    add_column :hr_election_times, :dissolution_date, :date, after: :expiration_date
  end
end

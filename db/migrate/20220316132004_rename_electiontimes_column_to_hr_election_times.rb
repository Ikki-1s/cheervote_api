class RenameElectiontimesColumnToHrElectionTimes < ActiveRecord::Migration[6.1]
  def change
    rename_column :hr_election_times, :election_times, :election_time
  end
end

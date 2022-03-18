class AddReelectionNumberToHcConstituency < ActiveRecord::Migration[6.1]
  def change
    add_column :hc_constituencies, :reelection_number, :integer, null: false, after: :quota
  end
end

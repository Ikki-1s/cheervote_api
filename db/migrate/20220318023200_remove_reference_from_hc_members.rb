class RemoveReferenceFromHcMembers < ActiveRecord::Migration[6.1]
  def up
    remove_foreign_key :hc_members, :political_parties
    remove_reference :hc_members, :political_party
  end
  
  def down
    add_reference :hc_members, :political_party, foreign_key: true
  end
end

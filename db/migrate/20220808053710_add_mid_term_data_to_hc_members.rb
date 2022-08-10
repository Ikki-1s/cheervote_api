class AddMidTermDataToHcMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :hc_members, :mid_term_start_date, :date, after: :hc_constituency_id
    add_column :hc_members, :mid_term_start_reason, :text, after: :mid_term_start_date
    add_column :hc_members, :mid_term_end_date, :date, after: :mid_term_start_reason
    add_column :hc_members, :mid_term_end_reason, :text, after: :mid_term_end_date
  end
end

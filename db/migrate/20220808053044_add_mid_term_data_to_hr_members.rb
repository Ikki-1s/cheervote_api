class AddMidTermDataToHrMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :hr_members, :mid_term_start_date, :date, after: :hr_pr_block_id
    add_column :hr_members, :mid_term_start_reason, :text, after: :mid_term_start_date
    add_column :hr_members, :mid_term_end_date, :date, after: :mid_term_start_reason
    add_column :hr_members, :mid_term_end_reason, :text, after: :mid_term_end_date
  end
end

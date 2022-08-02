class ChangeHrConstituencyCvsToHrCvs < ActiveRecord::Migration[6.1]
  def change
    rename_table :hr_constituency_cvs, :hr_cvs
    add_column :hr_cvs, :my_constituency_flg, :integer, after: :cv_evaluation_value_id
  end
end

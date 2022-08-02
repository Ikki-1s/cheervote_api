class ChangeHcConstituencyCvsToHcCvs < ActiveRecord::Migration[6.1]
  def change
    rename_table :hc_constituency_cvs, :hc_cvs
    add_column :hc_cvs, :my_constituency_flg, :integer, after: :cv_evaluation_value_id
  end
end

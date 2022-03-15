class CreateHcConstituencyCvs < ActiveRecord::Migration[6.1]
  def change
    create_table :hc_constituency_cvs do |t|
      t.references :hc_member, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :hc_cv_term, foreign_key: true, null: false
      t.references :cv_evaluation_value, foreign_key: true, null: false
      t.timestamps
    end
  end
end

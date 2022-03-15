class CreateHrConstituencyCvs < ActiveRecord::Migration[6.1]
  def change
    create_table :hr_constituency_cvs do |t|
      t.references :hr_member, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :hr_cv_term, foreign_key: true, null: false
      t.references :cv_evaluation_value, foreign_key: true, null: false
      t.timestamps
    end
  end
end

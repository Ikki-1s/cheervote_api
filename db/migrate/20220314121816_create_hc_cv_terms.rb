class CreateHcCvTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :hc_cv_terms do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.timestamps
    end
  end
end

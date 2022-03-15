class CreateCvEvaluationValues < ActiveRecord::Migration[6.1]
  def change
    create_table :cv_evaluation_values do |t|
      t.integer :value, null: false
      t.timestamps
    end
  end
end

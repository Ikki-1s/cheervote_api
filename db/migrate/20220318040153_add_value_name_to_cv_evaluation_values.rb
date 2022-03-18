class AddValueNameToCvEvaluationValues < ActiveRecord::Migration[6.1]
  def change
    add_column :cv_evaluation_values, :value_name, :string, after: :value
  end
end

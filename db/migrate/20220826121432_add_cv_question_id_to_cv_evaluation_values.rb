class AddCvQuestionIdToCvEvaluationValues < ActiveRecord::Migration[6.1]
  def up
    add_reference :cv_evaluation_values, :cv_question, after: :id, foreign_key: true, null: false
  end

  def down
    remove_foreign_key :cv_evaluation_values, :cv_questions
    remove_reference :cv_evaluation_values, :cv_question
  end
end

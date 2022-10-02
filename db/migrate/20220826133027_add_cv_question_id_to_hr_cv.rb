class AddCvQuestionIdToHrCv < ActiveRecord::Migration[6.1]
  def up
    add_reference :hr_cvs, :cv_question, after: :hr_cv_term_id, foreign_key: true, null: false
  end

  def down
    remove_foreign_key :hr_cvs, :cv_questions
    remove_reference :hr_cvs, :cv_question
  end
end

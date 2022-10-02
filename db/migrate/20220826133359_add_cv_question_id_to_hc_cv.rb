class AddCvQuestionIdToHcCv < ActiveRecord::Migration[6.1]
  def up
    add_reference :hc_cvs, :cv_question, after: :hc_cv_term_id, foreign_key: true, null: false
  end

  def down
    remove_foreign_key :hc_cvs, :cv_questions
    remove_reference :hc_cvs, :cv_question
  end
end

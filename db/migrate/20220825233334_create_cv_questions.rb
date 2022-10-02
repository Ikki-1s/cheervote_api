class CreateCvQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :cv_questions do |t|
      t.text :question_sentence
      t.text :note
      t.timestamps
    end
  end
end

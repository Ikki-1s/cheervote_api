class Api::V1::CvQuestionsController < ApplicationController
  def show
    cv_question = CvQuestion.select(:id, :question_sentence, :note).find_by(id: params[:id])
    render json: {
      "cv_question" => cv_question,
      "cv_evaluation_values" => cv_question.cv_evaluation_values.select(:id, :cv_question_id, :value, :value_name)
    }
  end
end

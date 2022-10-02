class HcCv < ApplicationRecord
  belongs_to :hc_member
  belongs_to :user
  belongs_to :hc_cv_term
  belongs_to :cv_question
  belongs_to :cv_evaluation_value
end

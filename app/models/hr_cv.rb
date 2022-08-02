class HrCv < ApplicationRecord
  belongs_to :hr_member
  belongs_to :user
  belongs_to :hr_cv_term
  belongs_to :cv_evaluation_value
end

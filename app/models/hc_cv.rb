class HcCv < ApplicationRecord
  belongs_to :hc_member
  belongs_to :user
  belongs_to :hc_cv_term
  belongs_to :cv_question
  belongs_to :cv_evaluation_value

  validates :hc_member_id, presence: true
  validates :user_id, presence: true, on: :create
  validates :hc_cv_term_id, presence: true
  validates :cv_question_id, presence: true
  validates :cv_evaluation_value_id, presence: true
  validates :my_constituency_flg, numericality: { equal_to: 1 }, allow_nil: true
  validate :vote_does_not_exist_in_same_term, on: :create

  private

  # 同じ投票受付期間に既に同じ議員に投票済みでないか検証
  # （参議院議員・ユーザー・支持投票期間・支持投票設問が同じレコードが既にないか検証）
  def vote_does_not_exist_in_same_term
    if HcCv.where(
      hc_member_id: hc_member_id,
      user_id: user_id,
      hc_cv_term_id: hc_cv_term_id,
      cv_question_id: cv_question_id).present?
      errors.add :base, :invalid, message: "同じ投票受付期間に既に投票済みです"
    end
  end
end

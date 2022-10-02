class HrCvTerm < ApplicationRecord
  has_many :hr_cvs

  # 指定した日時に該当する支持投票期間を取得
  def self.on_the_date_time(date_time: Time.current)
    where(
      "start_date <= ?", date_time,
    ).where(
      "end_date > ?", date_time
    )
  end
end

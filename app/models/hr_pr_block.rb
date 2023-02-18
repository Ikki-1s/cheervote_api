class HrPrBlock < ApplicationRecord
  has_many :hr_members
  has_many :hr_pr_block_prefs
  has_many :prefectures, through: :hr_pr_block_prefs

  # 都道府県.idを指定して、都道府県に紐づく
  # 衆議院比例代表ブロックを取得
  def self.of_pref(prefecture_id:)
    joins(
      hr_pr_block_prefs: :prefecture
    ).where(
      prefecture: { id: prefecture_id }
    ).as_json(
      except: [:created_at, :updated_at]
    )
  end
end

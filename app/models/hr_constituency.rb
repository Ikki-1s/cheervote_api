class HrConstituency < ApplicationRecord
  has_many :users
  belongs_to :prefecture
  has_many :hr_constituency_voters
  has_many :hr_members

  # 衆議院小選挙区.idを指定して、都道府県付きの衆議院小選挙区を取得
  def self.with_pref(hr_constituency_id:)
    eager_load(
      :prefecture
    ).where(
      id: hr_constituency_id
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        prefecture: {
          except: [:created_at, :updated_at],
        }
      }
    )
  end

end

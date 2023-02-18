class Politician < ApplicationRecord
  has_many :political_party_members
  has_many :political_parties, through: :political_party_members
  has_many :hr_members
  has_many :hc_members

  # 政治家.idから、紐づく関連テーブルのデータ全てを引き出す。
  #   支持投票テーブルからの取得も今後追加する
  def self.show_all_association_data(politician_id:)
    eager_load(
      hr_members: { hr_constituency: :prefecture },
      hr_members: :hr_election_time,
      hr_members: :hr_pr_block,
      hc_members: :hc_constituency,
      hc_members: :hc_election_time,
      political_party_members: :political_party
    ).where(
      id: politician_id
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        hr_members: {
          except: [:created_at, :updated_at],
          include: {
            hr_election_time: {
              except: [:created_at, :updated_at],
            },
            hr_constituency: {
              except: [:created_at, :updated_at],
              include: {
                prefecture: {
                  except: [:created_at, :updated_at],
                }
              }
            },
            hr_pr_block: {
              except: [:created_at, :updated_at],
            }
          }
        },
        hc_members: {
          except: [:created_at, :updated_at],
          include: {
            hc_election_time: {
              except: [:created_at, :updated_at],
            },
            hc_constituency: {
              except: [:created_at, :updated_at],
            }
          }
        },
        political_party_members: {
          except: [:created_at, :updated_at],
          include: {
            political_party: {
              except: [:created_at, :updated_at],
            }
          }
        }
      }
    )
  end
end

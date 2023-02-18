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
      only: [
        :id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana,
        :image, :career, :website, :twitter, :youtube, :facebook, :other_sns
      ],
      include: {
        hr_members: {
          only: [
            :id, :politician_id, :hr_election_time_id, :elected_system, :hr_constituency_id, :hr_pr_block_id,
            :mid_term_start_date, :mid_term_start_reason, :mid_term_end_date, :mid_term_end_reason
          ],
          include: {
            hr_election_time: {
              only: [:id, :election_time, :announcement_date, :election_date, :expiration_date, :dissolution_date]
            },
            hr_constituency: {
              only: [:id, :name, :prefecture_id],
              include: {
                prefecture: {
                  only: [:id, :prefecture]
                }
              }
            },
            hr_pr_block: {
              only: [:id, :block_name]
            }
          }
        },
        hc_members: {
          only: [
            :id, :politician_id, :hc_election_time_id, :elected_system, :hc_constituency_id,
            :mid_term_start_date, :mid_term_start_reason, :mid_term_end_date, :mid_term_end_reason
          ],
          include: {
            hc_election_time: {
              only: [:id, :election_time, :announcement_date, :election_date, :expiration_date]
            },
            hc_constituency: {
              only: [:id, :name]
            }
          }
        },
        political_party_members: {
          only: [:id, :politician_id, :political_party_id, :start_belonging_date, :end_belonging_date],
          include: {
            political_party: {
              only: [:id, :name_kanji, :name_kana, :abbreviation_kanji, :abbreviation_kana]
            }
          }
        }
      }
    )
  end
end

class HcMember < ApplicationRecord
  belongs_to :politician
  belongs_to :hc_election_time
  belongs_to :hc_constituency
  has_many :hc_constituency_cvs

  # 選挙区ごとの参議院議員
  def self.latest_of_hc_constituency(hc_constituency_id:, hc_election_time_ids:)
    eager_load(
      :hc_constituency,
      :hc_election_time,
      { politician: { political_party_members: :political_party } }
    ).where(
      hc_election_time_id: hc_election_time_ids,
      elected_system: 1,
      hc_constituency_id: hc_constituency_id
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      only: [:id],
      include: {
        hc_constituency: { only: [:id, :name, :quota] },
        hc_election_time: { only: [:id, :election_time, :expiration_date] },
        politician: {
          only: [:id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana],
          include: {
            political_party_members: {
              only: [],
              include: {
                political_party: {
                  only: [:name_kanji, :abbreviation_kanji]
                }
              }
            }
          }
        }
      }
    )
  end

  # 全国比例選出参議院議員
  def self.latest_of_hc_pr(hc_election_time_ids:)
    eager_load(
      :hc_election_time,
      { politician: { political_party_members: :political_party } }
    ).where(
      hc_election_time_id: hc_election_time_ids,
      elected_system: 2
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      only: [:id],
      include: {
        hc_election_time: { only: [:id, :election_time, :expiration_date] },
        politician: {
          only: [:id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana],
          include: {
            political_party_members: {
              only: [],
              include: {
                political_party: {
                  only: [:name_kanji, :abbreviation_kanji]
                }
              }
            }
          }
        }
      }
    )
  end
end

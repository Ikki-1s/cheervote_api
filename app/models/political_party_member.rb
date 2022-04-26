class PoliticalPartyMember < ApplicationRecord
  belongs_to :politician
  belongs_to :political_party

  # 指定した政党の衆議院議員の一覧を返す
  def self.political_party_hr_members(political_party_id:, hr_election_time_id:)
    eager_load(
      politician: { hr_members: { hr_constituency: :prefecture } }
    ).eager_load(
      politician: { hr_members: :hr_pr_block }
    ).where(
      political_party_id: political_party_id,
      hr_members: { hr_election_time_id: hr_election_time_id }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      only: [:id],
      include: {
        politician: {
          only: [:id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana],
          include: {
            hr_members: {
              only: [:id, :elected_system],
              include: {
                hr_constituency: {
                  only: [:id, :name],
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
            }
          }
        }
      }
    )
  end

  # 指定した政党の参議院議員の一覧を返す
  def self.political_party_hc_members(political_party_id:, hc_election_time_ids:)
    eager_load(
      politician: { hc_members: :hc_constituency }
    ).where(
      political_party_id: political_party_id,
      hc_members: { hc_election_time_id: hc_election_time_ids }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      only: [:id],
      include: {
        politician: {
          only: [:id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana],
          include: {
            hc_members: {
              only: [:id, :elected_system],
              include: {
                hc_constituency: {
                  only: [:id, :name]
                }
              }
            }
          }
        }
      }
    )
  end
end

class HrMember < ApplicationRecord
  belongs_to :politician
  belongs_to :hr_election_time
  belongs_to :hr_constituency
  belongs_to :hr_pr_block
  has_many :hr_constituency_cvs

  # 都道府県ごとの小選挙区選出衆議院議員
  def self.latest_of_prefecture(prefecture_id:, hr_election_time_id:)
    # eager_load(
    #   :hr_constituency, :politician
    # ).where(
    #   hr_election_time_id: hr_election_time_id, elected_system: 1, hr_constituencies:{prefecture_id: prefecture_id}
    # ).to_json(
    #   only: [:id],
    #   include: {
    #     hr_constituency: {only: [:id, :name]},
    #     politician: {only: [:id, :last_name_kanji, :first_name_kanji]}
    #   }
    # )
    eager_load(
      :hr_constituency, { politician: { political_party_members: :political_party } }
    ).where(
      hr_election_time_id: hr_election_time_id, elected_system: 1, hr_constituencies: { prefecture_id: prefecture_id }
    ).order(
      "hr_constituencies.id ASC"
    ).to_json(
      only: [:id],
      include: {
        hr_constituency: { only: [:id, :name] },
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

  # 比例代表ブロックごとの比例代表ブロック選出衆議院議員
  def self.latest_of_hr_pr_block(hr_pr_block_id:, hr_election_time_id:)
    eager_load(
      :hr_pr_block, { politician: { political_party_members: :political_party } }
    ).where(
      hr_election_time_id: hr_election_time_id, elected_system: 2, hr_pr_blocks: { id: hr_pr_block_id }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      only: [:id],
      include: {
        hr_pr_block: { only: [:id, :block_name, :quota] },
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

class PoliticalPartyMember < ApplicationRecord
  belongs_to :politician
  belongs_to :political_party

  # 指定した政党の衆議院議員の一覧を返す
  # ・選挙回を指定しなければ最新の選挙回で出力する。
  def self.political_party_hr_members(
    political_party_id:, hr_election_time_id: HrElectionTime.last.id
  )
    eager_load(
      politician: { hr_members: { hr_constituency: :prefecture } }
    ).eager_load(
      politician: { hr_members: :hr_pr_block }
    ).where(
      political_party_id: political_party_id,
      hr_members: { hr_election_time_id: hr_election_time_id, mid_term_end_date: nil }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      only: [:id],
      include: {
        politician: {
          only: [:id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana, :image],
          include: {
            hr_members: {
              only: [:id, :politician_id, :hr_election_time_id, :elected_system],
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
  # ・選挙回を指定しなければ最新の選挙回で出力する。
  def self.political_party_hc_members(political_party_id:, hc_election_time_ids: HcElectionTime.pluck(:id).last(2))
    eager_load(
      politician: { hc_members: :hc_constituency }
    ).where(
      political_party_id: political_party_id,
      hc_members: { hc_election_time_id: hc_election_time_ids, mid_term_end_date: nil }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      only: [:id],
      include: {
        politician: {
          only: [:id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana],
          include: {
            hc_members: {
              only: [:id, :politician_id, :hc_election_time_id, :elected_system],
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

  # 指定した選挙回の各政党の衆議院議員数を出力する
  # ・選挙回を指定しなければ最新の選挙回で出力する。
  # ・政党.idの昇順に出力される。
  # 出力形式：
  # {[政党.id, 政党.政党名（漢字）]=>議員数, 〜}
  # {[1, "無所属"]=>3, [2, "自由民主党"]=>262, 〜 [11, "無所属／有志の会"]=>5}
  def self.political_party_hr_members_count(hr_election_time_id: HrElectionTime.last.id)
    hr_id_count = PoliticalPartyMember.eager_load(
      :political_party, { politician: :hr_members }
    ).where(
      hr_members: { hr_election_time_id: hr_election_time_id, mid_term_end_date: nil }
    # ).where(
    #   hr_members: { mid_term_end_date: nil },
    ).group(
      "political_parties.id",
      "political_parties.name_kanji"
    ).order(
      # "count_id desc",
      # "political_parties.name_kana asc"
      "political_parties.id asc"
    ).count
  end

  # 指定した選挙回の各政党の参議院議員数を出力する
  # ・選挙回を指定しなければ現役となる選挙回（直近2回の選挙回）で出力する。
  # ・政党.idの昇順に出力される。
  # 出力形式：
  # {[政党.id, 政党.政党名（漢字）]=>議員数, 〜}
  # {[1, "無所属"]=>8, [2, "自由民主党"]=>117, 〜 [15, "参政党"]=>1}
  def self.political_party_hc_members_count(hc_election_time_id: HcElectionTime.pluck(:id).last(2))
    hc_id_count = PoliticalPartyMember.eager_load(
      :political_party, { politician: :hc_members }
    ).where(
      hc_members: { hc_election_time_id: hc_election_time_id, mid_term_end_date: nil }
    # ).where(
    #   hc_members: { mid_term_end_date: nil },
    ).group(
      "political_parties.id",
      "political_parties.name_kanji"
    ).order(
      # "count_id desc",
      # "political_parties.name_kana asc"
      "political_parties.id asc"
    ).count
  end
end

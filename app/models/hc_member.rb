class HcMember < ApplicationRecord
  belongs_to :politician
  belongs_to :hc_election_time
  belongs_to :hc_constituency
  has_many :hc_cvs

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

  # 政治家.id（、参議院選挙回.id、途中任期開始日）を指定して参議院議員を取得
    # 政治家.idのみの指定の場合、現役の参議院議員を取得する
    # 値は配列内にハッシュを含む形で取得（取得できない場合は空の配列が返る）
    #
    # mid_term_end_dateでnil以外を指定したい場合は、
    # 指定する参議院選挙回の「election_date以上」のように指定する
    # （例.「"2022-7-1"..」、「HcElectionTime.last.election_date..」）
  def self.of_politician_on_hc_election_time(politician_id:, hc_election_time_ids: HcElectionTime.pluck(:id).last(2), mid_term_end_date: nil)
    eager_load(
      :hc_election_time,
      :hc_constituency,
      politician: { political_party_members: :political_party }
    ).where(
      politician_id: politician_id,
      hc_election_time_id: hc_election_time_ids,
      mid_term_end_date: mid_term_end_date
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        hc_election_time: {
          except: [:created_at, :updated_at],
        },
        hc_constituency: {
          only: [:id, :name]
        },
        politician: {
          except: [:created_at, :updated_at],
          include: {
            political_party_members: {
              except: [:created_at, :updated_at],
              include: {
                political_party: {
                  except: [:created_at, :updated_at]
                }
              }
            }
          }
        }
      }
    )
  end
end

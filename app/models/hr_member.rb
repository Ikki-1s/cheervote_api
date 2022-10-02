class HrMember < ApplicationRecord
  belongs_to :politician
  belongs_to :hr_election_time
  belongs_to :hr_constituency
  belongs_to :hr_pr_block
  has_many :hr_cvs

  # 都道府県ごとの小選挙区選出衆議院議員
  def self.latest_of_prefecture(prefecture_id:, hr_election_time_id:)
    eager_load(
      :hr_constituency, { politician: { political_party_members: :political_party } }
    ).where(
      hr_election_time_id: hr_election_time_id, elected_system: 1, hr_constituencies: { prefecture_id: prefecture_id }
    ).order(
      "hr_constituencies.id ASC"
    ).as_json(
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
    ).as_json(
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

  # 政治家.id（、衆議院選挙回.id、途中任期開始日）を指定して衆議院議員を取得
    # 政治家.idのみの指定の場合、現役の衆議院議員を取得する
    # 値は配列内にハッシュを含む形で取得（取得できない場合は空の配列が返る）
    #
    # mid_term_end_dateでnil以外を指定したい場合は、
    # 指定する衆議院選挙回の「election_date以上」のように指定する
    # （例.「"2022-7-1"..」、「HrElectionTime.last.election_date..」）
  def self.of_politician_on_hr_election_time(politician_id:, hr_election_time_id: HrElectionTime.last.id, mid_term_end_date: nil)
    eager_load(
      :hr_election_time,
      :hr_constituency,
      :hr_pr_block,
      politician: { political_party_members: :political_party }
    ).where(
      politician_id: politician_id,
      hr_election_time_id: hr_election_time_id,
      mid_term_end_date: mid_term_end_date
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        hr_election_time: {
          except: [:created_at, :updated_at],
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

class HrMember < ApplicationRecord
  belongs_to :politician
  belongs_to :hr_election_time
  belongs_to :hr_constituency
  belongs_to :hr_pr_block
  has_many :hr_cvs

  # 都道府県.idを指定して都道府県ごとの小選挙区選出衆議院議員を取得
    # 【引数】
    # prefecture_id（都道府県.id）
    # hr_election_time_id（衆議院選挙回.id）
    # ・指定しない場合、デフォルト値で最新の選挙回が入る
    # mid_term_end_date（途中任期終了日）
    # ・指定しない場合、デフォルト値でnilが入る
    # ・mid_term_end_dateでnil以外を指定したい場合は、
    # 　指定する衆議院選挙回の「election_date以上」のように指定する
    # 　（例.「"2022-7-1"..」、「HrElectionTime.last.election_date..」）
  def self.of_prefecture(
    prefecture_id:,
    hr_election_time_id: HrElectionTime.last.id,
    mid_term_end_date: nil
  )
    eager_load(
      :hr_constituency,
      { politician: { political_party_members: :political_party } }
    ).where(
      hr_election_time_id: hr_election_time_id,
      elected_system: 1,
      mid_term_end_date: mid_term_end_date,
      hr_constituencies: { prefecture_id: prefecture_id }
    ).order(
      "hr_constituencies.id ASC"
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        hr_constituency: { except: [:created_at, :updated_at] },
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

  # 衆議院比例代表ブロック.idを指定して比例代表ブロック選出衆議院議員を取得
    # 【引数】
    # hr_pr_block_id（衆議院比例代表ブロック.id）
    # hr_election_time_id（衆議院選挙回.id）
    # ・指定しない場合、デフォルト値で最新の選挙回が入る
    # mid_term_end_date（途中任期終了日）
    # ・指定しない場合、デフォルト値でnilが入る
    # ・mid_term_end_dateでnil以外を指定したい場合は、
    # 　指定する衆議院選挙回の「election_date以上」のように指定する
    # 　（例.「"2022-7-1"..」、「HrElectionTime.last.election_date..」）
  def self.of_hr_pr_block(
    hr_pr_block_id:,
    hr_election_time_id: HrElectionTime.last.id,
    mid_term_end_date: nil
  )
    eager_load(
      :hr_pr_block,
      { politician: { political_party_members: :political_party } }
    ).where(
      hr_election_time_id: hr_election_time_id,
      elected_system: 2,
      mid_term_end_date: mid_term_end_date,
      hr_pr_blocks: { id: hr_pr_block_id }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        hr_pr_block: { except: [:created_at, :updated_at] },
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

  # 衆議院小選挙区.idを指定して衆議院議員を取得
    # 【引数】
    # hr_constituency_id（衆議院小選挙区.id）
    # hr_election_time_id（衆議院選挙回.id）
    # ・指定しない場合、デフォルト値で最新の選挙回が入る
    # elected_system（衆議院議員.当選方式）（1: 小選挙区, 2: 比例）
    # ・指定しなければ、デフォルト値で小選挙区選出議員のみ取得
    # ・[1, 2]を指定すると、比例代表選出議員で小選挙区重複立候補者も含めて取得
    # mid_term_end_date（途中任期終了日）
    # ・指定しない場合、デフォルト値でnilが入る
    # ・mid_term_end_dateでnil以外を指定したい場合は、
    # 　指定する衆議院選挙回の「election_date以上」のように指定する
    # 　（例.「"2022-7-1"..」、「HrElectionTime.last.election_date..」）
  def self.of_hr_constituency(
    hr_constituency_id:,
    hr_election_time_id: HrElectionTime.last.id,
    elected_system: 1,
    mid_term_end_date: nil
  )
    eager_load(
      hr_constituency: :prefecture,
      politician: { political_party_members: :political_party }
    ).where(
      hr_constituency: { id: hr_constituency_id },
      hr_election_time_id: hr_election_time_id,
      elected_system: elected_system,
      mid_term_end_date: mid_term_end_date,
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        hr_constituency: {
          except: [:created_at, :updated_at],
          include: {
            prefecture: {
              except: [:created_at, :updated_at]
            }
          }
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


  # 小選挙区と比例代表ブロックを指定して、両選出方式の衆議院議員を一度に取得
  # ※途中任期終了日が入っているものも含んで取得しているため、front側で処理必要
  # def self.of_both_systems(hr_constituency_id:, hr_pr_block_id:, hr_election_time_id: HrElectionTime.last.id)
  #   relation = eager_load(
  #     :hr_constituency,
  #     :hr_pr_block,
  #     politician: { political_party_members: :political_party }
  #   )
  #
  #   relation.where(
  #     hr_election_time_id: hr_election_time_id,
  #     hr_constituencies: { id: hr_constituency_id }
  #   ).or(
  #     relation.where(
  #       hr_election_time_id: hr_election_time_id,
  #       hr_pr_block: { id: hr_pr_block_id }
  #     )
  #   # ).where(
  #   #   mid_term_end_date: nil
  #   ).order(
  #     "elected_system ASC, hr_constituency_id ASC"
  #   ).order(
  #     "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
  #   ).as_json(
  #     except: [:created_at, :updated_at],
  #     include: {
  #       hr_constituency: {
  #         except: [:created_at, :updated_at]
  #       },
  #       hr_pr_block: {
  #         except: [:created_at, :updated_at]
  #       },
  #       politician: {
  #         except: [:created_at, :updated_at],
  #         include: {
  #           political_party_members: {
  #             except: [:created_at, :updated_at],
  #             include: {
  #               political_party: {
  #                 except: [:created_at, :updated_at]
  #               }
  #             }
  #           }
  #         }
  #       }
  #     }
  #   )
  # end
end

class PoliticalPartyMember < ApplicationRecord
  belongs_to :politician
  belongs_to :political_party

  # 政党.idを指定して政党の衆議院議員一覧を返す
    # 【引数】
    # political_party_id（政党.id）
    # hr_election_time_id（衆議院選挙回.id）
    # ・指定しない場合、デフォルト値で最新の選挙回が入る
    # end_belonging_date（所属終了年月日）
    # ・指定しない場合、デフォルト値でnilが入る
    # ・end_belonging_dateでnil以外を指定したい場合は、
    # 　指定する衆議院選挙回の「election_date以上」のように指定する
    # 　（例.「"2022-7-1"..」、「HrElectionTime.last.election_date..」）
  def self.political_party_hr_members(
    political_party_id:,
    hr_election_time_id: HrElectionTime.last.id,
    end_belonging_date: nil
  )
    eager_load(
      politician: { hr_members: { hr_constituency: :prefecture } }
    ).eager_load(
      politician: { hr_members: :hr_pr_block }
    ).where(
      political_party_id: political_party_id,
      end_belonging_date: end_belonging_date,
      hr_members: { hr_election_time_id: hr_election_time_id, mid_term_end_date: nil }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      except: [:created_at, :updated_at],
      include: {
        politician: {
          except: [:created_at, :updated_at],
          include: {
            hr_members: {
              except: [:created_at, :updated_at],
              include: {
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
            }
          }
        }
      }
    )
  end

  # 政党.idを指定して政党の参議院議員一覧を返す
    # 【引数】
    # political_party_id（政党.id）
    # hc_election_time_ids（参議院選挙回.id）
    # ・指定しない場合、デフォルト値で直近２回の選挙回（現役議員分）が入る
    # end_belonging_date（所属終了年月日）
    # ・指定しない場合、デフォルト値でnilが入る
    # ・end_belonging_dateでnil以外を指定したい場合は、
    # 　指定する参議院選挙回の「election_date以上」のように指定する
    # 　（例.「"2022-7-1"..」、「HcElectionTime.last.election_date..」）
  def self.political_party_hc_members(
    political_party_id:,
    hc_election_time_ids: HcElectionTime.pluck(:id).last(2),
    end_belonging_date: nil
  )
    eager_load(
      politician: { hc_members: :hc_constituency }
    ).where(
      political_party_id: political_party_id,
      end_belonging_date: end_belonging_date,
      hc_members: { hc_election_time_id: hc_election_time_ids, mid_term_end_date: nil }
    ).order(
      "politicians.last_name_kana ASC, politicians.first_name_kana ASC"
    ).to_json(
      except: [:created_at, :updated_at],
      include: {
        politician: {
          except: [:created_at, :updated_at],
          include: {
            hc_members: {
              except: [:created_at, :updated_at],
              include: {
                hc_constituency: {
                  except: [:created_at, :updated_at],
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
      end_belonging_date: nil,
      hr_members: { hr_election_time_id: hr_election_time_id, mid_term_end_date: nil }
    # ).where(
    #   hr_members: { mid_term_end_date: nil },
    ########### ゲストログイン機能用 ###########
    ).where.not(
      political_party_id: 17
    ########### ゲストログイン機能用 ###########
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
      end_belonging_date: nil,
      hc_members: { hc_election_time_id: hc_election_time_id, mid_term_end_date: nil }
    # ).where(
    #   hc_members: { mid_term_end_date: nil },
    ########### ゲストログイン機能用 ###########
    ).where.not(
      political_party_id: 17
    ########### ゲストログイン機能用 ###########
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

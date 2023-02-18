class PoliticalParty < ApplicationRecord
  has_many :political_party_members
  has_many :politicians, through: :political_party_members

  #  指定した選挙回の国会議員のいる政党一覧を出力
  #  ・選挙会を指定しなければ現役となる選挙回（衆：直近1回、参：直近2回）で出力
  #  ・所属国会議員数（衆議院＋参議院）の多い政党順
  #  ・現在所属議員のいない政党は除外
  #  ・無所属、無所属の会派は配列の末尾に寄せる
  # 　※association上PoliticalPartyMemberから取ってしまっている。
  #    整合性の取れた取り方があれば直したい。
  #
  #   出力形式：
  #   [{"id"=>2, "name_kanji"=>"自由民主党", "name_kana"=>"じゆうみんしゅとう", "total"=>379, "hr_count"=>262, "hc_count"=>117},
  #    {"id"=>3, "name_kanji"=>"立憲民主党", "name_kana"=>"りっけんみんしゅとう", "total"=>134, "hr_count"=>96, "hc_count"=>38},
  #      〜
  #    {"id"=>15, "name_kanji"=>"参政党", "name_kana"=>"さんせいとう", "total"=>1, "hr_count"=>0, "hc_count"=>1},
  #    {"id"=>1, "name_kanji"=>"無所属", "name_kana"=>"むしょぞく", "total"=>11, "hr_count"=>3, "hc_count"=>8},
  #      〜
  #    {"id"=>14, "name_kanji"=>"無所属／みんなの党", "name_kana"=>"むしょぞくみんなのとう", "total"=>1, "hr_count"=>0, "hc_count"=>1}]
  #
  def self.having_active_members(
    hr_election_time_id: HrElectionTime.last.id,
    hc_election_time_id: HcElectionTime.pluck(:id).last(2)
  )
    # 政党一覧取得
    political_parties = PoliticalParty.pluck(:id, :name_kanji, :name_kana)

    # 衆議院
    hr_id_count = PoliticalPartyMember.political_party_hr_members_count(
      hr_election_time_id: hr_election_time_id
    )

    # 参議院
    hc_id_count = PoliticalPartyMember.political_party_hc_members_count(
      hc_election_time_id: hc_election_time_id
    )

    # 政党一覧に各院の議員数を追加し、ハッシュの配列を出力
    # 出力形式：
    #   [{"id"=>1, "name_kanji"=>"無所属", "name_kana"=>"むしょぞく", "total"=>11, "hr_count"=>3, "hc_count"=>8},
    #    {"id"=>2, "name_kanji"=>"自由民主党", "name_kana"=>"じゆうみんしゅとう", "total"=>379, "hr_count"=>262, "hc_count"=>117}]
    political_parties_have_count = political_parties.map do | political_party |
      hr_count = 0
      hc_count = 0

      hr_id_count.each do | key, value |
        if political_party[0] == key[0]
          hr_count = value
        end
      end

      hc_id_count.each do | key, value |
        if political_party[0] == key[0]
          hc_count = value
        end
      end

      total_count = hr_count + hc_count

      political_party << total_count
      political_party << hr_count
      political_party << hc_count

      # ハッシュ化
      {
        "id" => political_party[0],
        "name_kanji" => political_party[1],
        "name_kana" => political_party[2],
        "total" => political_party[3],
        "hr_count" => political_party[4],
        "hc_count" => political_party[5],
      }
    end

    # 合計国会議員数が0の政党は除外
    political_parties_have_count.reject! { |x| x["total"] == 0 }

    # 合計議員数（降順）、政党名かな（昇順）に並べ替え（-は数値にのみ有効）
    political_parties_have_count.sort_by { |x| [-x["total"], x["name_kana"]] }

    # 無所属系は最後尾に配置
    partisan, nonpartisan = political_parties_have_count.partition { |x| !x["name_kanji"].include?("無所属") }
    nonpartisan.each do |x|
      partisan << x
    end

    partisan
  end
end

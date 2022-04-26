class PoliticalParty < ApplicationRecord
  has_many :political_party_members
  has_many :politicians, through: :political_party_members

  #  政党一覧を出力
  #  ・所属国会議員数（衆議院＋参議院）の多い政党順
  #  ・現在所属議員のいない政党は除外
  # 　※association上PoliticalPartyMemberから取ってしまっている。
  #    整合性の取れた取り方が分かれば直したい。
  def self.having_active_members(hr_election_time_id:, hc_election_time_ids:)
    relation = PoliticalPartyMember.eager_load(
      :political_party, { politician: :hr_members }, { politician: :hc_members }
    )
    political_party_ids = relation.where(
      hr_members: { hr_election_time_id: hr_election_time_id }
    ).or(
      relation.where(
        hc_members: { hc_election_time_id: hc_election_time_ids }
      )
    ).group(
      "political_parties.id"
    ).order(
      count_id: :desc
    ).count.keys
    political_party_names = relation.where(
      hr_members: { hr_election_time_id: hr_election_time_id }
    ).or(
      relation.where(
        hc_members: { hc_election_time_id: hc_election_time_ids }
      )
    ).group(
      "political_parties.name_kanji"
    ).order(
      count_id: :desc
    ).count.keys
    political_parties_order_by_number_of_members = []
    political_party_ids.zip(political_party_names) do |id, name|
      political_parties_order_by_number_of_members << { "id" => id, "name" => name }
    end
    political_parties_order_by_number_of_members
  end
end

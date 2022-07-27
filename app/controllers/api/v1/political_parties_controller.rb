class Api::V1::PoliticalPartiesController < ApplicationController
  def show
    political_party = PoliticalParty.select(:id, :name_kanji, :name_kana, :abbreviation_kanji,
                                            :abbreviation_kana).where(id: params[:id])
    render json: political_party
  end

  #  政党一覧
  #  ・所属国会議員数（衆議院＋参議院）の多い政党順
  #  ・現在所属議員のいない政党は除外
  def index_having_active_members
    latest_hr_election_time_id = HrElectionTime.last.id
    active_hc_election_time_ids = HcElectionTime.pluck(:id).last(2)
    political_parties = PoliticalParty.having_active_members(hr_election_time_id: latest_hr_election_time_id,
                                                             hc_election_time_ids: active_hc_election_time_ids)
    render json: political_parties
  end
end

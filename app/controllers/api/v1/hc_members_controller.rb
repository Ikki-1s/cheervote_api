class Api::V1::HcMembersController < ApplicationController
  # 選挙区ごとの参議院議員
  def index_of_hc_constituency
    active_hc_election_time_ids = HcElectionTime.pluck(:id).last(2)
    hc_members = HcMember.latest_of_hc_constituency(hc_constituency_id: params[:id],
                                                    hc_election_time_ids: active_hc_election_time_ids)
    render json: hc_members
  end

  # 全国比例選出参議院議員
  def index_of_hc_pr
    active_hc_election_time_ids = HcElectionTime.pluck(:id).last(2)
    hc_members = HcMember.latest_of_hc_pr(hc_election_time_ids: active_hc_election_time_ids)
    render json: hc_members
  end
end

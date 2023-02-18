class Api::V1::PoliticalPartyMembersController < ApplicationController
  def index_of_hr_members
    # latest_hr_election_time_id = HrElectionTime.last.id
    # hr_members = PoliticalPartyMember.political_party_hr_members(political_party_id: params[:id],
    #                                                              hr_election_time_id: latest_hr_election_time_id)
    hr_members = PoliticalPartyMember.political_party_hr_members(political_party_id: params[:id])
    render json: hr_members
  end

  def index_of_hc_members
    # active_hc_election_time_ids = HcElectionTime.pluck(:id).last(2)
    # hc_members = PoliticalPartyMember.political_party_hc_members(political_party_id: params[:id],
    #                                                              hc_election_time_ids: active_hc_election_time_ids)
    hc_members = PoliticalPartyMember.political_party_hc_members(political_party_id: params[:id])
    render json: hc_members
  end
end

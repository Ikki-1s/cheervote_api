class Api::V1::HrMembersController < ApplicationController
  def index
  end

  def index_of_prefecture
    # 都道府県ごとの小選挙区選出衆議院議員
    latest_hr_election_time_id = HrElectionTime.last.id
    hr_members = HrMember.latest_of_prefecture(prefecture_id: params[:id],
                                               hr_election_time_id: latest_hr_election_time_id)
    render json: hr_members
  end
end

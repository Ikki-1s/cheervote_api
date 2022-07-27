class Api::V1::HrMembersController < ApplicationController
  # 都道府県ごとの小選挙区選出衆議院議員
  def index_of_prefecture
    latest_hr_election_time_id = HrElectionTime.last.id
    hr_members = HrMember.latest_of_prefecture(prefecture_id: params[:id],
                                               hr_election_time_id: latest_hr_election_time_id)
    render json: hr_members
  end

  # 比例代表ブロックごとの比例代表ブロック選出衆議院議員
  def index_of_hr_pr_block
    latest_hr_election_time_id = HrElectionTime.last.id
    hr_members = HrMember.latest_of_hr_pr_block(hr_pr_block_id: params[:id],
                                                hr_election_time_id: latest_hr_election_time_id)
    render json: hr_members
  end
end

class Api::V1::HcMembersController < ApplicationController
  # 選挙区ごとの参議院議員
  def index_of_hc_constituency
    hc_members = HcMember.of_hc_constituency(
      hc_constituency_id: params[:id]
    )
    render json: hc_members
  end

  # 全国比例選出参議院議員
  def index_of_hc_pr
    hc_members = HcMember.of_hc_pr
    render json: hc_members
  end
end

class Api::V1::HcConstituenciesController < ApplicationController
  def index
    hc_constituencies = HcConstituency.select(:id, :name, :quota, :reelection_number)
    render json: hc_constituencies
  end

  def show
    hc_constituency = HcConstituency.select(:id, :name, :quota, :reelection_number).where(id: params[:id])
    render json: hc_constituency
  end
end

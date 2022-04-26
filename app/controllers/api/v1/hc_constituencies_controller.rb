class Api::V1::HcConstituenciesController < Api::V1::ApplicationController
  def index
    hc_constituencies = HcConstituency.select(:id, :name, :quota)
    render json: hc_constituencies
  end

  def show
    hc_constituency = HcConstituency.select(:id, :name, :quota).where(id: params[:id])
    render json: hc_constituency
  end
end

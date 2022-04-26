class Api::V1::PrefecturesController < Api::V1::ApplicationController
  def index
    prefectures = Prefecture.select(:id, :prefecture)
    render json: prefectures
  end

  def show
    prefecture = Prefecture.select(:id, :prefecture).where(id: params[:id])
    render json: prefecture
  end
end

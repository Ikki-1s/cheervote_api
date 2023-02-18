class Api::V1::PrefecturesController < ApplicationController
  def index
    prefectures = Prefecture.select(:id, :prefecture)
    render json: prefectures
  end

  def show
    prefecture = Prefecture.select(:id, :prefecture).where(id: params[:id])
    render json: prefecture
  end

  # 全ての都道府県とそれに紐づく衆議院小選挙区、衆議院比例代表ブロック、参議院選挙区を出力
  def index_with_all_constituencies_and_blocks
    prefectures = Prefecture.with_all_constituencies_and_blocks
    render json: prefectures
  end
end

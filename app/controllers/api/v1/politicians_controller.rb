class Api::V1::PoliticiansController < ApplicationController
  def index
    politicians = Politician.select(
      :id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana,
      # :id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana,
      # :career, :website, :twitter, :youtube, :facebook, :other_sns
    )
    render json: politicians
  end

  def show
    # politician = Politician.select(
    #   :id, :last_name_kanji, :first_name_kanji, :last_name_kana, :first_name_kana,
    #   :career, :website, :twitter, :youtube, :facebook, :other_sns
    # ).where(
    #   id: params[:id]
    # )
    politician = Politician.show_all_association_data(politician_id: params[:id])
    render json: politician
  end
end

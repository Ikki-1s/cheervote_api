class Api::V1::SignedInHomesController < ApplicationController
  # ログイン後のCHEERVOTE TOPページ表示用データを返す
  def index
    if current_api_v1_user
      data = SignedInHome.user_home_data(
        signed_in_user: current_api_v1_user
      )
      render json: data
    end
  end
end

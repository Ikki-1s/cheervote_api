class Api::V1::CheervotesController < ApplicationController

    def show
      data = Cheervote.is_possible?(
        politician_id: params[:id],
        login_user: current_api_v1_user
      )

      if current_api_v1_user
        render json: { "is_login" => true }.merge(data)
      else
        render json: { "is_login" => false }.merge(data)
      end

    end
end

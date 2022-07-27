# アカウント作成用コントローラー
class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

    def sign_up_params
      params.permit(:name, :email, :password, :password_confirmation, :hr_constituency_id, :hc_constituency_id, :prefecture_id)
    end

    def account_update_params
      params.permit(:name, :email)
    end
end

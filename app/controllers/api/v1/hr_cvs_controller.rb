class Api::V1::HrCvsController < ApplicationController
  def create
    if current_api_v1_user
      is_possible_cheervote = Cheervote.is_possible?(politician_id: params[:politician_id], login_user: current_api_v1_user)

      # リクエストパラメータが現在のモデル状態と矛盾していないかチェックの上createするデータをセット
      if is_possible_cheervote["is_login_user_possible_to_cv_on_term"] &&
        is_possible_cheervote["hr_member"]["id"] == params[:member_id] &&
        is_possible_cheervote["current_cv_term"]["id"] == params[:cv_term_id]

        cheervote_create_data = HrCv.new(
          hr_member_id: is_possible_cheervote["hr_member"]["id"],
          user_id: current_api_v1_user.id,
          hr_cv_term_id: is_possible_cheervote["current_cv_term"]["id"],
          cv_question_id: params[:cv_question_id],
          cv_evaluation_value_id: params[:cv_evaluation_id]
        )

        # マイ選挙区フラグセット
        if is_possible_cheervote["is_my_constituency_member"]
          cheervote_create_data.my_constituency_flg = 1
        end

        # 登録
        if cheervote_create_data.save
          render json: { data: { message: "成功" } }, status: :created # 201
        else
          render json: { data: { message: "登録時サーバーエラー" } }, status: :internal_server_error # 500
        end

      else
        render json: { data: { message: "リクエストパラメータが不正です" } }, status: :bad_request # 400
      end
    else
      render json: { data: { message: "ログインエラー" } }, status: :unauthorized # 401
    end
  end

end

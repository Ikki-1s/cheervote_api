class Api::V1::CheervotesController < ApplicationController

    # 支持投票ページ表示用データ出力
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

    # 政治家.id、支持投票設問.idを指定し、円グラフ表示用の
    # 支持投票評価値テーブルの評価値名、支持投票テーブルの評価値毎の集計値を出力
    def result_for_pie_chart
      result = Cheervote.result_for_pie_chart(
        politician_id: params[:politician],
        cv_term_id: params[:cv_term],
        cv_question_id: params[:cv_question],
        my_constituency_flg: params[:my_constituency_flg]
      )
      render json: result
    end

    # 政治家.idを指定し、その政治家の現役の期間分の支持投票期間のリストを出力
    def active_cv_terms_of_politician
      result = Cheervote.active_cv_terms_of_politician(politician_id: params[:politician])
      render json: result
    end
end

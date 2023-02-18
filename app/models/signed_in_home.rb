class SignedInHome < ApplicationRecord
  # ログイン後のCHEERVOTE TOPページ表示用データを取得
  # 【引数】
  # signed_in_user:
  # ・current_api_v1_userをそのまま受け取る
  def self.user_home_data(signed_in_user:)
    ### ユーザー名取得 ###
    user_name = signed_in_user["name"]

    ### マイ選挙区情報取得 ###
    # 衆議院小選挙区情報
    hr_constituency = HrConstituency.with_pref(
      hr_constituency_id: signed_in_user["hr_constituency_id"]
    ).first

    # 衆議院比例代表ブロック抽出
    hr_pr_block = HrPrBlock.of_pref(
      prefecture_id: signed_in_user["prefecture_id"]
    ).first

    # 参議院選挙区抽出
    hc_constituency = HcConstituency.where(
      id: signed_in_user["hc_constituency_id"]
    ).as_json(except: [:created_at, :updated_at]).first

    ### 現在の評価投票受付期間情報取得 ###
    # 評価投票受付期間（衆議院）
    # hr_cv_term = HrCvTerm.on_the_date_time.first
    hr_cv_term = HrCvTerm.on_the_date_time.as_json(
      except: [:created_at, :updated_at]
    ).first

    # 評価投票受付期間（参議院）
    hc_cv_term = HcCvTerm.on_the_date_time.as_json(
      except: [:created_at, :updated_at]
    ).first

    ### 衆議院議員情報取得 ###
    # ※現在は小選挙区選出議員のみ取得
    hr_members = HrMember.of_hr_constituency(
      hr_constituency_id: signed_in_user["hr_constituency_id"]
    )

    ### 参議院議員情報取得 ###
    hc_members = HcMember.of_hc_constituency(
      hc_constituency_id: signed_in_user["hc_constituency_id"]
    )

    ### ログインユーザーの評価投票状況を取得し ###
    ### 取得した議員情報に評価投票状況を付与  ###
    ## 衆議院議員 ##
    # 評価投票受付期間（衆議院）がnilでない場合
    if hr_cv_term
      # 評価投票（衆議院）取得
      hr_cv_of_signed_in_user = HrCv.where(
        user_id: signed_in_user["id"],
        hr_cv_term_id: hr_cv_term["id"]
      )
      # 取得した衆議院議員に評価投票が可能かどうか判定
      hr_members_added_vote_status = hr_members.map do |member|
        is_voted = false
        hr_cv_of_signed_in_user.each do |cv|
          if cv["hr_member_id"] == member["id"]
            is_voted = true
          end
        end
        # 「vote_status: "voted" or "unvoted"」を付与
        if is_voted
          member.merge({"voted_status" => "voted"})
        else
          member.merge({"voted_status" => "unvoted"})
        end
      end
    # 評価投票受付期間（衆議院）がnilの場合
    else
      # 「vote_status: "out_of_term"」を付与
      hr_members_added_vote_status = hr_members.map {
        |member| member.merge({"voted_status" => "out_of_term"})
      }
    end

    ## 参議院議員 ##
    # 評価投票受付期間（参議院）がnilでない場合
    if hc_cv_term
      # 評価投票（参議院）取得
      hc_cv_of_signed_in_user = HcCv.where(
        user_id: signed_in_user["id"],
        hc_cv_term_id: hc_cv_term["id"]
      )
      # 取得した参議院議員に評価投票が可能かどうか判定
      hc_members_added_vote_status = hc_members.map do |member|
        is_voted = false
        hc_cv_of_signed_in_user.each do |cv|
          if cv["hc_member_id"] == member["id"]
            is_voted = true
          end
        end
        # 「vote_status: "voted" or "unvoted"」を付与
        if is_voted
          member.merge({"voted_status" => "voted"})
        else
          member.merge({"voted_status" => "unvoted"})
        end
      end
    # 評価投票受付期間（参議院）がnilの場合
    else
      # 「vote_status: "out_of_term"」を付与
      hc_members_added_vote_status = hc_members.map {
        |member| member.merge({"voted_status" => "out_of_term"})
      }
    end

    ### データ集約して返却 ###
    {
      "user_name" => user_name,
      "hr_constituency" => hr_constituency,
      "hr_pr_block" => hr_pr_block,
      "hc_constituency" => hc_constituency,
      "current_hr_cv_term" => hr_cv_term,
      "current_hc_cv_term" => hc_cv_term,
      "hr_members" => hr_members_added_vote_status,
      "hc_members" => hc_members_added_vote_status,
    }
  end
end

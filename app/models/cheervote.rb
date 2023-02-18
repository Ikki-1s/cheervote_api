class Cheervote < ApplicationRecord

  def self.is_possible?(politician_id:, login_user:)

    ### 現役議員判定（取得） ###
    # 現役議員の衆議院議員テーブルを取得
    hr_member = HrMember.of_politician_on_hr_election_time(
      politician_id: politician_id
    ).first

    # 現役議員の参議院議員テーブルを取得
    hc_member = HcMember.of_politician_on_hc_election_time(
      politician_id: politician_id,
    ).first


    ### 支持投票受付期間判定（取得） ###
    if hr_member
      current_cv_term = HrCvTerm.on_the_date_time.first
    elsif hc_member
      current_cv_term = HcCvTerm.on_the_date_time.first
    else
      current_cv_term = nil
    end


    ### ログインユーザーのマイ選挙区議員判定
    # 衆議院議員の場合
    if hr_member &&
      login_user &&
      hr_member["elected_system"] == 1 &&
      # hr_member["hr_constituency_id"] == login_user.hr_constituency_id # どちらでも可
      hr_member["hr_constituency_id"] == login_user["hr_constituency_id"]

      is_my_constituency_member = true

    # 参議院議員の場合
    elsif hc_member &&
      login_user &&
      hc_member["elected_system"] == 1 &&
      # hc_member["hc_constituency_id"] == login_user.hc_constituency_id # どちらでも可
      hc_member["hc_constituency_id"] == login_user["hc_constituency_id"]

      is_my_constituency_member = true

    else
      is_my_constituency_member = false
    end


    ### ログインユーザーが現在の支持投票可能期間に投票済みでないか判定 ###
    # 衆議院議員
    if hr_member && current_cv_term && is_my_constituency_member

      if !HrCv.where(
        hr_member_id: hr_member["id"],
        user_id: login_user.id,
        hr_cv_term_id: current_cv_term["id"]
      ).first
        is_login_user_possible_to_cv_on_term = true
      else
        is_login_user_possible_to_cv_on_term = false
      end

    # 参議院議員
    elsif hc_member && current_cv_term && is_my_constituency_member

      if !HcCv.where(
        hc_member_id: hc_member["id"],
        user_id: login_user.id,
        hc_cv_term_id: current_cv_term["id"]
      ).first
        is_login_user_possible_to_cv_on_term = true
      else
        is_login_user_possible_to_cv_on_term = false
      end

    else
      is_login_user_possible_to_cv_on_term = nil
    end


    ### データ集約して返却 ###
    merged_house_member_data = { "current_cv_term" => current_cv_term.as_json }.merge(
      { "is_my_constituency_member" => is_my_constituency_member },
      { "is_login_user_possible_to_cv_on_term" => is_login_user_possible_to_cv_on_term }
    )

    # 衆議院議員
    if hr_member
      { "is_active_house_member" => true }.merge(
        { "hr_member" => hr_member },
        merged_house_member_data
      )
    # 参議院議員
    elsif hc_member
      { "is_active_house_member" => true }.merge(
        { "hc_member" => hc_member },
        merged_house_member_data
      )
    else
      { "is_active_house_member" => false }
    end

  end


  # 円グラフ表示用支持投票結果出力
  def self.result_for_pie_chart(politician_id:, cv_term_id: nil, cv_question_id:, my_constituency_flg:)
    ### 現役議員判定（取得） ###
    # 現役議員の衆議院議員テーブルを取得
    hr_member = HrMember.of_politician_on_hr_election_time(
      politician_id: politician_id
    ).first

    # 現役議員の参議院議員テーブルを取得
    hc_member = HcMember.of_politician_on_hc_election_time(
      politician_id: politician_id,
    ).first

    labels = []
    which_house = nil
    cv_counts = nil
    cv_total = nil

    if hr_member || hc_member
      # 支持投票設問.idを指定し、支持投票評価値テーブルを取得
      cv_evaluation_values = CvEvaluationValue.where(
        cv_question_id: cv_question_id
      ).order("value asc")

      # 上記で指定した支持投票設問の支持投票評価値名一覧を取得
      # 例：["大変支持する", "まあまあ支持する", "どちらでもない", "あまり支持しない", "全く支持しない"]
      labels = cv_evaluation_values.map { |m| m.value_name }

      ### 支持投票評価値毎の集計値・支持投票数合計を取得 ###
      cv_evaluation_value_ids = cv_evaluation_values.map { |m| m.id }
      # マイ選挙区フラグの値指定なしの場合、どちらの場合も取得する
      my_constituency_flg ||= [0, 1]

      if hr_member
        which_house = "hr"

        cv_term_id ||= HrCvTerm.on_the_date_time.first.id
        # 支持投票数合計
        cv_total = HrCv.where(
            hr_member_id: hr_member["id"],
            hr_cv_term_id: cv_term_id,
            cv_question_id: cv_question_id,
            my_constituency_flg: my_constituency_flg,
          ).count
        # 支持投票評価値毎の集計値
        cv_counts = cv_evaluation_value_ids.map {
          |id| HrCv.where(
            hr_member_id: hr_member["id"],
            hr_cv_term_id: cv_term_id,
            cv_question_id: cv_question_id,
            my_constituency_flg: my_constituency_flg,
            cv_evaluation_value_id: id
          ).count
        }
      # hc_member = trueの場合
      else
        which_house = "hc"

        cv_term_id ||= HcCvTerm.on_the_date_time.first.id
        # 支持投票数合計
        cv_total = HcCv.where(
            hc_member_id: hc_member["id"],
            hc_cv_term_id: cv_term_id,
            cv_question_id: cv_question_id,
            my_constituency_flg: my_constituency_flg,
          ).count
        # 支持投票評価値毎の集計値
        cv_counts = cv_evaluation_value_ids.map {
          |id| HcCv.where(
            hc_member_id: hc_member["id"],
            hc_cv_term_id: cv_term_id,
            cv_question_id: cv_question_id,
            my_constituency_flg: my_constituency_flg,
            cv_evaluation_value_id: id
          ).count
        }
      end
    end

    { "labels" => labels, "which_house" => which_house, "data" => cv_counts, "total" => cv_total }
  end


  # 政治家.idを指定し、その政治家の現役の期間分の支持投票期間のリストを出力
  def self.active_cv_terms_of_politician(politician_id:)
    # 現役議員の衆議院議員テーブルを取得
    hr_member = HrMember.of_politician_on_hr_election_time(
      politician_id: politician_id
    ).first

    # 現役議員の参議院議員テーブルを取得
    hc_member = HcMember.of_politician_on_hc_election_time(
      politician_id: politician_id,
    ).first

    active_cv_terms = if hr_member
      active_term_from = hr_member["hr_election_time"]["election_date"]
      active_cv_terms = HrCvTerm.where(
        "start_date > ?", active_term_from
      ).select(
        :id, :start_date, :end_date
      ).order(
        "id desc"
      )
    elsif hc_member
      active_term_from = hc_member["hc_election_time"]["election_date"]
      active_cv_terms = HcCvTerm.where(
        "start_date > ?", active_term_from
      ).select(
        :id, :start_date, :end_date
      ).order(
        "id desc"
      )
    else
      # なにもしない
      []
    end
  end

end

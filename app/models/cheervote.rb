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


    ### ログインユーザーが現在の支持投票可能期間に投票済みでないか判定
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
    except_house_member_data = { "current_cv_term" => current_cv_term.as_json }.merge(
      { "is_my_constituency_member" => is_my_constituency_member },
      { "is_login_user_possible_to_cv_on_term" => is_login_user_possible_to_cv_on_term }
    )

    # 衆議院議員
    if hr_member
      { "is_active_house_member" => true }.merge(
        { "hr_member" => hr_member },
        except_house_member_data
      )
    # 参議院議員
    elsif hc_member
      { "is_active_house_member" => true }.merge(
        { "hc_member" => hc_member },
        except_house_member_data
      )
    else
      { "is_active_house_member" => false }
    end

  end

end

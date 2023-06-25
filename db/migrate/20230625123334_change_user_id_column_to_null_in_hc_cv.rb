class ChangeUserIdColumnToNullInHcCv < ActiveRecord::Migration[6.1]
  def up
    change_column_null :hc_cvs, :user_id, true
  end

  def down
    change_column_null :hc_cvs, :user_id, false
  end
end

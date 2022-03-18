class ChangeColumnsRemoveNullFromPolitician < ActiveRecord::Migration[6.1]
  def change
    change_column_null :politicians, :first_name_kanji, true
    change_column_null :politicians, :first_name_kana, true
  end
end

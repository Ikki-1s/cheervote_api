class ChangeUsersAddInitialColumns < ActiveRecord::Migration[6.1]
  def up
    add_reference :users, :hr_constituency, foreign_key: true
    add_reference :users, :hc_constituency, foreign_key: true
    add_reference :users, :prefecture, foreign_key: true
    change_column :users, :name, :string, limit: 30, null: false
  end

  def down
    remove_foreign_key :users, :hr_constituencies
    remove_reference :users, :hr_constituency

    remove_foreign_key :users, :hc_constituencies
    remove_reference :users, :hc_constituency
    
    remove_foreign_key :users, :prefectures
    remove_reference :users, :prefecture

    change_column :users, :name, :string, limit: 255, null: true
  end
end

class AddBirthdayInstagramLineToPoliticians < ActiveRecord::Migration[6.1]
  def change
    add_column :politicians, :birthday, :date, after: :image
    add_column :politicians, :instagram, :string, after: :facebook
    add_column :politicians, :line, :string, after: :instagram
  end
end

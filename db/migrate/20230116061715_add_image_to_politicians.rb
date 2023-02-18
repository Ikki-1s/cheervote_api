class AddImageToPoliticians < ActiveRecord::Migration[6.1]
  def change
    add_column :politicians, :image, :string, after: :first_name_kana
  end
end

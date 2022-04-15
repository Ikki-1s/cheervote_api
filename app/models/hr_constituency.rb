class HrConstituency < ApplicationRecord
  has_many :users
  belongs_to :prefecture
  has_many :hr_constituency_voters
  has_many :hr_members
end

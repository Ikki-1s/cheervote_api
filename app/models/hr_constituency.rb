class HrConstituency < ApplicationRecord
  has_many :users
  belongs_to :prefecture
  has_many :hr_constituency_voter
  has_many :hr_members
end

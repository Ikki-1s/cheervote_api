class Politician < ApplicationRecord
  has_many :political_party_members
  has_many :political_parties, through: :political_party_members
  has_many :hr_members
  has_many :hc_members
end

class PoliticalParty < ApplicationRecord
  has_many :political_party_members
  has_many :politicians, through: :political_party_members
end

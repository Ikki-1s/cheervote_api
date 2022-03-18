class HcConstituency < ApplicationRecord
  has_many :users
  has_many :hc_constituency_prefs
  has_many :prefectures, through: :hc_constituency_prefs
  has_many :hc_constituency_voters
  has_many :hc_members
end

class Prefecture < ApplicationRecord
  has_many :users
  has_many :hr_constituencies
  has_many :hr_members, through: :hr_constituencies
  belongs_to :hc_constituency_pref
  has_many :hc_constituencies, through: :hc_constituency_prefs
end

class Prefecture < ApplicationRecord
  has_many :users
  has_many :hr_constituencies
  has_many :hc_constituencies
  has_many :hc_constituencies, through: :hc_constituency_prefs
end

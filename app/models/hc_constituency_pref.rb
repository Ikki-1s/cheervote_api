class HcConstituencyPref < ApplicationRecord
  has_many :prefectures
  belongs_to :hc_constituency
end

class HcMember < ApplicationRecord
  belongs_to :politician
  belongs_to :hc_election_time
  belongs_to :hc_constituency
  has_many :hc_constituency_cvs
end

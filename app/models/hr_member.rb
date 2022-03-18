class HrMember < ApplicationRecord
  belongs_to :politician
  belongs_to :hr_election_time
  belongs_to :hr_constituency
  belongs_to :hr_pr_block
  has_many :hr_constituency_cvs
end

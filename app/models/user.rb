# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  belongs_to :hr_constituency
  belongs_to :hc_constituency
  belongs_to :prefecture
  has_many :hr_constituency_cvs
  has_many :hc_constituency_cvs
end

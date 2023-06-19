# frozen_string_literal: true

# class User < ActiveRecord::Base
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User
  belongs_to :hr_constituency
  belongs_to :hc_constituency
  belongs_to :prefecture
  has_many :hr_cvs
  has_many :hc_cvs

  def self.guest
    create do |user|
      user.email = SecureRandom.alphanumeric(15) + "@guests.cheervote.jp"
      user.name = "ゲスト"
      user.password = SecureRandom.urlsafe_base64
      user.prefecture_id = 48
      user.hr_constituency_id = 290
      user.hc_constituency_id = 46
      user.confirmation_sent_at = Time.now.utc
      user.confirmation_token = SecureRandom.base64(20)
      user.skip_confirmation!
    end
  end
end

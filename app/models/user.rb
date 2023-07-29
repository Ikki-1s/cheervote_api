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
  has_many :hr_cvs, dependent: :nullify
  has_many :hc_cvs, dependent: :nullify

  # email, passwordのvalidationはdeviseで実施（config/initializers/devise.rbでカスタマイズ）
  validates :name, presence: true, length: { maximum: 30 }
  validates :prefecture_id, presence: true
  validates :hr_constituency_id, presence: true
  validates :hc_constituency_id, presence: true
  validate :hr_constituency_id_is_included_in_prefecture,
    :hc_constituency_id_is_included_in_prefecture

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

  private

  # 選択した都道府県に含まれる衆議院小選挙区かどうか検証
  def hr_constituency_id_is_included_in_prefecture
    unless HrConstituency.where(prefecture: prefecture_id).pluck(:id).include?(hr_constituency_id)
      errors.add(:hr_constituency_id, "選択した都道府県に含まれる衆議院小選挙区ではありません")
    end
  end

  # 選択した都道府県に含まれる参議院選挙区かどうか検証
  def hc_constituency_id_is_included_in_prefecture
    unless HcConstituencyPref.where(prefecture: prefecture_id).pluck(:hc_constituency_id).include?(hc_constituency_id)
      errors.add(:hc_constituency_id, "選択した都道府県に含まれる参議院選挙区ではありません")
    end
  end
end

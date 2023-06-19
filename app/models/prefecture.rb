class Prefecture < ApplicationRecord
  has_many :users
  has_many :hr_constituencies
  has_many :hr_members, through: :hr_constituencies
  has_one :hc_constituency_pref
  has_one :hc_constituency, through: :hc_constituency_pref
  has_one :hr_pr_block_pref
  has_one :hr_pr_block, through: :hr_pr_block_pref

  # 全ての都道府県とそれに紐づく衆議院小選挙区、衆議院比例代表ブロック、参議院選挙区を出力
  def self.with_all_constituencies_and_blocks
    eager_load(
      :hr_constituencies,
      hr_pr_block_pref: :hr_pr_block,
      hc_constituency_pref: :hc_constituency
    ########### ゲストログイン機能用 ###########
    ).where.not(
      id: 48
    ########### ゲストログイン機能用 ###########
    ).order(
      "prefectures.id ASC"
    ).as_json(
      except: [:created_at, :updated_at],
      include: {
        hr_constituencies: {
          except: [:created_at, :updated_at],
        },
        hr_pr_block_pref: {
          except: [:created_at, :updated_at],
          include: {
            hr_pr_block: {
              except: [:created_at, :updated_at],
            }
          }
        },
        hc_constituency_pref: {
          except: [:created_at, :updated_at],
          include: {
            hc_constituency: {
              except: [:created_at, :updated_at],
            }
          }
        }
      }
    )
  end
end

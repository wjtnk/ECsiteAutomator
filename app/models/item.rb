class Item < ApplicationRecord
  belongs_to :account
  has_many :comments, dependent: :destroy
 #  validates :csv, presence: true
 #  validates :item_name,   presence: true, length: { maximum: 30}
 #  validates :description,   presence: true, length: { maximum: 1000}
 #  validates :category1,     presence: true, numericality: true
 #  validates :category2,     presence: true, numericality: true
 #
 #  validates :state,
 #  presence: true, numericality: { only_integer: true,
 #  greater_than: -1, less_than: 6
 #  }
 #
 #  validates :ship_fee,
 #  presence: true, numericality: { only_integer: true,
 #  greater_than: -1, less_than: 3
 #  }
 #
 #  validates :ship_method, presence: true, numericality: true
 #
 #  validates :ship_from,
 #  presence: true, numericality: { only_integer: true,
 #  greater_than: 0, less_than: 48
 #  }
 #
 #  validates :ship_day,
 #  presence: true, numericality: { only_integer: true,
 #  greater_than: -1, less_than: 3
 #  }
 #
 # validates :purchase_application,
 # presence: true, numericality: { only_integer: true,
 # greater_than: -1, less_than: 2
 # }
 #
 #  validates :price,             presence: true,  numericality: true
 #
 #  validate :tags_character_size
 #  validate :ship_method_check
 #
 #  def tags_character_size
 #      if !tags.nil? && tags.gsub("：","").gsub(":","").size > 20 #タグが存在し、かつ２０文字以上ならエラー
 #        errors.add(:tags, "タグは20文字以内です")
 #     end
 #  end
 #
 #  def ship_method_check
 #     unless ship_method == 3 or ship_method == 14 or ship_method == 8 or ship_method == 2 or ship_method == 4 or ship_method == 0
 #        errors.add(:ship_method, "そのような配送方法はありません")
 #     end
 #  end


end

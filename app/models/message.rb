class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  
  # 各レコードとファイルを1対1の関係で紐づける :ファイル名
  has_one_attached :image

  validates :content, presence: true
end
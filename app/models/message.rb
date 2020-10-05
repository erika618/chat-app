class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  # 各レコードとファイルを1対1の関係で紐づける :ファイル名
  has_one_attached :image

  validates :content, presence: true, unless: :was_attached?
  # validatesのunlessオプションにメソッド名を指定することで、「メソッドの返り値がfalseならばバリデーションによる検証を行う」という条件を作っている。
  def was_attached?
    self.image.attached?
  end
  # 画像があればtrue。
end
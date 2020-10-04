class Room < ApplicationRecord
  has_many :room_users  
  has_many :users, through: :room_users, dependent: :destroy
  has_many :messages, dependent: :destroy 
  # 親モデルを削除したとき、関連しているモデルの挙動をどうするか指定できるオプション。Room（親モデル）が削除されたときに、Message（子モデル）とUser（子モデル）が通るRoomUser（中間テーブルのモデル）も削除される。 
  validates :name, presence: true
  # 「ルーム名が存在（presence）している場合のみ作成可（true）」という意味
end

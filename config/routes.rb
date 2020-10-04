Rails.application.routes.draw do
  devise_for :users
  root to: "rooms#index"
  resources :users, only: [:edit, :update,]
  # userのアクションがこの二つなのは後付けしたのがこの二つだから（それ以外はデバイスないで処理）
  resources :rooms, only: [:new, :create] do
    resources :messages, only: [:index, :create]
  end
  # ルーティングのネスト！ルームズが親で、メッセージズが子、チャットルームに属しているメッセージとなる。これによって、メッセーじに結びつく、ルームのidを含んだパスを受け取れるようになる。
end

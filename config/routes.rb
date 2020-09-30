Rails.application.routes.draw do
  devise_for :users
  root to: "messages#index"
  resources :users, only: [:edit, :update,]
  # userのアクションがこの二つなのは後付けしたのがこの二つだから（それ以外はデバイスないで処理）
end

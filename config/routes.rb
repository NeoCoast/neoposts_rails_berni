Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, only: %i[index update] do
        member do
          post 'follow'
          post 'unfollow'
        end
      end
      resources :posts, only: %i[create show index]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

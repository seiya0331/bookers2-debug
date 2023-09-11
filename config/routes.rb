Rails.application.routes.draw do
  get 'relationships/followings'
  get 'relationships/followers'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:show,:edit,:update]
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :follows, :followers
    end
      resource :relationships, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "home/about"=>"homes#about"
  get "search"=>"searches#search"

end

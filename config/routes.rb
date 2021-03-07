Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get "/dashboard" => "home#dashboard"
  resources :uploads, only: [:index, :create]
  get "/add_users" => "users#index"
  post '/add_users' => 'users#create'
end

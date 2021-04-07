require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get "/dashboard" => "dashboard#index"
  get "/dashboard/attacks_per_day" => "dashboard#attacks_per_day"
  resources :uploads, only: [:index, :create]
  get "/manage_users" => "users#index"

  get '/create_users' => 'users#add_user'
  post '/create_users' => 'users#create'

  get '/user_profile' => 'users#profile'
  patch '/update_profile' => 'users#update_profile'
  delete '/delete_user' => 'users#delete_user'

  get "/attacks" => "attacks#index"
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end

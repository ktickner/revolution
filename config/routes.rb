Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root 'feed_events#index'
  
  resources :user_profiles
  resources :genres
  resources :events
end

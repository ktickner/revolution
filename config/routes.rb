Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root 'events#index'
  
  resource :user_profiles
  resource :genres
  resource :events
end

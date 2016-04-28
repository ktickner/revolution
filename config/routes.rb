Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root 'feed_events#index'
  
  resources :user_profiles
  resources :genres
  resources :events
  
  post 'event_response', to: 'user_event_responses#update', as: :event_response
  
  get 'reactivate_account', to: 'user_profiles#reactivate_account', as: :reactivate_account
  get 'activate_user', to: 'user_profiles#activate_user', as: :activate_user
  get 'remove_event', to: 'events#remove_from_feed', as: :remove_event
end

Rails.application.routes.draw do
  resources :messages
  resources :user_trips
  resources :events
  resources :trips
  resources :users
  resources :register

  # Custom Get Requests, see controller for more info
  get 'user_info/:user_id'  => 'users#user_info'
  get 'messages_by_trip/:trip_id' => 'messages#messages_by_trip'
  get 'events_by_trip/:trip_id' => 'events#events_by_trip'
  get 'trips_by_user/:user_id' => 'trips#trips_by_user'
  get 'find_trip/:trip_id' => 'trips#find_trip'

  # Custom post requests, see controller for more info
  post 'user_token' => 'user_token#create'
  post 'join_trip' => 'trips#join'
  post 'trips_by_user' => 'trips#trips_by_user'

  # Custom Patch request, see controller for more info
  patch 'trip' => 'trips#update'

  # Custom Delete request, see controller for more info
  delete 'delete_event/:id' => 'events#destroy'

end

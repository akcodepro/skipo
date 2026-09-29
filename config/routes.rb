Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :shared_workouts, only: [:index], path: "feed"
  resources :workout_sessions, only: [:index], path: "progress"
  resources :workouts, only: [:new], path: "train"

  # Health check for uptime monitors: returns 200 if the app boots.
  get "up" => "rails/health#show", as: :rails_health_check
end

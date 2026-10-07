Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root to: "workouts#new", as: :authenticated_root
  end

  unauthenticated do
    root to: "pages#home"
  end

  resources :shared_workouts, only: [ :index ], path: "feed"

  resources :workout_sessions, only: [ :index, :show, :update ], path: "progress"

  resources :workouts, only: [ :new, :create, :show ], path: "train" do
    resources :workout_sessions, only: [ :create ]
    collection do
      get :generating
    end
  end
  # Health check for uptime monitors: returns 200 if the app boots.
  get "up" => "rails/health#show", as: :rails_health_check
end

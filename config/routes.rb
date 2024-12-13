Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  get "privacy_policies" => "privacy_policies#index", as: :privacy_policies
  get "terms_of_services" => "terms_of_services#index", as: :terms_of_services

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :contacts, only: [ :new, :create ]
  resources :quiz_posts do
    collection do
      get :bookmarks
    end
  end

  get "tags" => "tags#index", as: :tags
  get "rankings" => "rankings#index", as: :rankings
  resource :mypage, only: [ :show, :edit, :update ]
  resources :otherspage, only: [ :show ]
  resources :questions, only: [ :show ] do
    collection do
      get "result"
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "quiz_posts#index"
end

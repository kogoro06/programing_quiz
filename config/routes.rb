Rails.application.routes.draw do
  devise_for :users

  get "privacy_policies/index"
  get "terms_of_services/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :contacts, only: [ :new, :create ]
  resources :quiz_posts do
    collection do
      get :bookmarks
    end
  end

  get "tags/index"
  get "rankings/index"
  resource :mypage, only: [ :show, :edit, :update ]
  resources :otherspage, only: [ :show ]
  resources :questions, only: [ :show ]
  get "questions/result"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # お問い合わせ、利用規約、プライバシーポリシー
  get "contact", to: "pages#contact", as: "contact"
  get "terms", to: "pages#terms", as: "terms"
  get "privacy", to: "pages#privacy", as: "privacy"

  # Defines the root path route ("/")
  root "quiz_posts#index"
end

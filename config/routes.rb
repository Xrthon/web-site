Rails.application.routes.draw do
  
  

  #Elles disent à Rails quelles URLs existent, vers quels controllers elles vont, et quels helpers _path Rails crée
  resource :session
  resource :registration, only: [:new, :create]
  resource :profile, only: [:show, :new, :create, :edit, :update]
  resource :email_verification, only: [:show, :create]


  resources :passwords, param: :token




  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
  get "dashboard", to:"pages#dashboard"
  

  get "registrations/new"
  get "email_verifications/show"
  get "/email_verification/:token",
    to: "email_verifications#verify",
    as: :verify_email
end

Rails.application.routes.draw do
  devise_for :users, module: "users", skip: [:session, :registration]

  as :user do
    get "login" => "users/sessions#new", as: :new_user_session
    post "login" => "users/sessions#create"
    get "logout" => "users/sessions#destroy"
    get "sign_up" => "users/registrations#new"
    post "sign_up" => "users/registrations#create"
    get "forgot_password" => "users/passwords#new"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end

Rails.application.routes.draw do
  devise_for :users, module: "users", skip: [:session, :registration]
  as :user do
    get "login" => "users/sessions#new", as: :new_user_session
    post "login" => "users/sessions#create"
    get "logout" => "users/sessions#destroy"
    get "sign_up" => "users/registrations#new"
    post "sign_up" => "users/registrations#create"
    get "forgot_password" => "users/passwords#new"
    post "forgot_password" => "users/passwords#create"
  end
  namespace :users do
    resources :infos, only: [:show, :update]
  end
  get "change_password" => "users/infos#get_change_password"
  put "change_password" => "users/infos#change_password"

  get "cart" => "carts#show"
  post "cart" => "carts#add_item"
  delete "cart" => "carts#remove_item"
  delete "empty_cart" => "carts#empty_cart"

  get "orders" => "orders#index"
  get "orders/checkout" => "orders#checkout"
  post "orders/payment"
  post "orders/reorder"
  get "orders/complete"
  patch "orders" => "orders#cancel", as: :order_cancel
  get "orders/:id" => "orders#show", as: :order

  post "stripe/webhook"

  draw(:admin)

  root "home#index"
end

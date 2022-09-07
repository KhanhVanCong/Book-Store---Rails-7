Rails.application.routes.draw do
  devise_for :users, module: "users"

  as :user do
    get "login" => "users/sessions#new"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

namespace :cms do
  devise_for :admins, module: "cms/admins", skip: [:session, :registration]
  devise_scope :cms_admin do
    get "login" => "admins/sessions#new", as: :login
    post "login" => "admins/sessions#create", as: :admin_session
    get "logout" => "admins/sessions#destroy"
  end
  resources :admins, except: :show

  resources :books, except: :show do
    delete "purge/:image_id" => "books#pure_image", as: "purge_image", on: :member
  end

  resources :authors, except: :show
  resources :tags, except: :show
  resources :categories, except: :show

  delete "attachments/:id/purge" => "attachments#purge", as: "purge_attachment"

  root "books#index"
end
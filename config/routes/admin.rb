namespace :cms do
  root "books#index"

  resources :books, except: :show do
    delete "purge/:image_id" => "books#pure_image", as: "purge_image", on: :member
  end

  resources :authors, except: :show
  resources :tags, except: :show
  resources :categories, except: :show

  delete "attachments/:id/purge" => "attachments#purge", as: "purge_attachment"
end
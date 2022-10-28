namespace :cms do
  root "books#index"

  resources :books, except: :show do
    delete "purge/:image_id" => "books#pure_image", as: "purge_image", on: :member
  end
  delete "attachments/:id/purge" => "attachments#purge", as: "purge_attachment"
end
Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'create_fast',to: 'users#create_fast'

  get 'main' ,to: 'users#login'
  post 'main' , to: 'users#check'
  get "users/:user_id/posts/new", to: "users#newpost", as: "new_post"
  post "users/:user_id/posts/new", to: "users#addpost", as: "add_post"
  get "users/:user_id/posts/:post_id/edit", to: "users#editpost", as: "edit_post"
  patch "users/:user_id/posts/:post_id/edit", to: "users#updatepost", as: "update_post"
  delete "users/:user_id/posts/:post_id/delete", to: "users#deletepost", as: "delete_post"
end

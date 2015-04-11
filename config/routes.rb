Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root 'pages#home'

  get 'contact'   => "pages#contact"

  get 'sessions/new'
  get 'signup'    => "users#new"

  get 'login'     => "sessions#new"
  post 'login'    => "sessions#create"
  delete 'logout' => "sessions#destroy"

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :articles
end

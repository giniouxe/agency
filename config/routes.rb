Rails.application.routes.draw do

  root            'pages#home'

  get 'contact'   => "pages#contact"
  get 'signup'    => "users#new"

  get 'sessions/new'
  get 'login'     => "sessions#new"
  post 'login'    => "sessions#create"
  delete 'logout' => "sessions#destroy"

  resources :users
end

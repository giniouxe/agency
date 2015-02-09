Rails.application.routes.draw do
  get 'sessions/new'

  root            'pages#home'

  get 'contact'   => "pages#contact"
  get 'signup'    => "users#new"

  get 'login'     => "sessions#new"
  post 'login'    => "sessions#create"
  get 'logout'    => "sessions#destroy  "

  resources :users
end

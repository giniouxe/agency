Rails.application.routes.draw do
  root            'pages#home'

  get 'contact'   => "pages#contact"
  get 'signup'    => "users#new"

  resources :users
end

Rails.application.routes.draw do

  get 'users/new'

  root            'pages#home'

  get 'help'      => "pages#help"
  get 'about'     => "pages#about"
  get 'contact'   => "pages#contact"
end

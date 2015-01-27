Rails.application.routes.draw do
  root 'pages#home'

  get 'pages/help'

  get 'pages/about'
end

Rails.application.routes.draw do
  resources :sizes
  
  resources :categories

  resources :products

  resources :users

  root "home#index"




end

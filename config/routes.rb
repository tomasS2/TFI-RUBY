Rails.application.routes.draw do
  resources :sizes
  
  resources :categories

  resources :products

  root "home#index"




end

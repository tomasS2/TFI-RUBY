Rails.application.routes.draw do
  resources :colours

  resources :app_users, controller: 'users' do
    member do
      get :deactivate 
      get :activate
      get :update_password_activate
    end
  end

  devise_scope :user do
    get 'users/sign_out' => "devise/sessions#destroy"
  end
  devise_for :users, only: [:sessions], controllers: {
    sessions: 'users/sessions', 
  }

  
  resources :sizes
  resources :categories

  resources :products do 
    collection do 
      get :index_administration
    end
    member do 
      get :show_stock
      patch :modify_stock
      patch :soft_delete
    end
  end
  get 'product_category/:primary_category_id', to: 'products#index', as: 'filter_by_checkbox'
  get 'products/search', to: 'products#index', as: 'search_products'

  resource :cart, only: [:show] do
    post 'add_item', to: 'carts#add_item', as: 'add_item'
    delete 'clear_cart', to: 'carts#clear_cart', as: 'clear_cart'
  end

  resources :cart_items, only: [:destroy, :update]

  resources :sales do 
    member do
      get :show_products
      post :cancel
    end
  end
  root "home#index"
end

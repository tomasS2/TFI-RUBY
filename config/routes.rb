Rails.application.routes.draw do

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
  devise_for :users, only: [:sessions, :registrations, :passwords], controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions', 
    passwords: 'users/passwords', 
  }
  #resources :sizes
  #resources :categories

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

  root "home#index"
end

Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  resources :payment_methods, only: %i[new create show destroy index]

  root 'home#index'
  resources :companies, only: %i[edit update show] do
    put '/cancel_registration', to: 'companies#cancel_registration'
  end
end

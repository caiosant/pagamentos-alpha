Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  root 'home#index'
  resources :payment_methods, only: %i[new create show destroy]
  resources :companies, only: %i[edit update show]
end

Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
    
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: '/dashboard'

    resources :payment_methods, only: %i[new create show destroy index], shallow: true do
      post 'enable', on: :member
      post 'disable', on: :member
    end
  end

  root 'home#index'
  resources :companies, only: %i[edit update show]
end

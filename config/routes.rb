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
  resources :companies, only: %i[edit update show] do
    get '/payment_settings', to: 'companies#payment_settings'
    put '/cancel_registration', to: 'companies#cancel_registration'
  end

  resources :pix_settings, only: %i[new create]

  resources :boleto_settings, only: %i[new create]

  resources :credit_card_settings, only: %i[new create]

  namespace :api do
    namespace :v1 do
      resources :customer, only: %i[index show create]
      resources :pix_settings, only: %i[index show]
      resources :boleto_settings, only: %i[index show]
      resources :credit_card_settings, only: %i[index show]
      resources :customer_payment_method, only: %i[index create]
    end
  end

  resources :products, only: %i[new create show index] do
    post 'enable', on: :member
    post 'disable', on: :member
  end

  resources :subscriptions, only: %i[new create show] do
    post 'enable', on: :member
    post 'disable', on: :member
  end
end

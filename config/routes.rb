Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  resources :payment_methods, only: %i[new create show destroy index]

  root 'home#index'
  resources :companies, only: %i[edit update show] do 
    get '/payment_settings', to: 'companies#payment_settings'
  end

  resources :pix_settings, only: %i[new create]

  resources :boleto_settings, only: %i[new create]

  resources :credit_card_settings, only: %i[new create]
end

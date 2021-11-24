Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  resources :payment_methods, only: %i[new create show destroy index]

  root 'home#index'
  resources :companies, only: %i[index edit update show] do
    get 'pending', on: :collection

    post 'accept', on: :member

    resources :rejected_companies, only: %i[new create]
  end
end

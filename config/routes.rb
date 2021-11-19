Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  resources :payment_methods, only: %i[new create show destroy index], shallow: true do
    post 'enable', on: :member
    post 'disable', on: :member
  end

  root 'home#index'
  resources :companies, only: %i[edit update show]
end

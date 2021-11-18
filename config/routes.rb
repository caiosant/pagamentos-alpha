Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'
  resources :companies, only: %i[edit update show] do
    put '/cancel_registration', to: 'companies#cancel_registration'
  end
end

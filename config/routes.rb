Rails.application.routes.draw do
  get 'home/index'

  # Skip Devise controllers we override and want to handle ourselves.
  devise_for :users, skip: [:confirmations, :registrations, :sessions]
  Rails.application.routes.draw do
    devise_for :users, controllers: {
      # Add routes for Devise controllers we override and want to handle
      # ourselves here.
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }
  end

  root 'home#index'
end

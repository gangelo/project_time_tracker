Rails.application.routes.draw do
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

=begin
    get 'users/index'
    get 'users/new'
    get 'users/edit'
    get 'users/show'
    get 'home/index'
=end

    resources :users

  root 'home#index'
end

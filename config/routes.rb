Rails.application.routes.draw do
  scope "(:locale)" do
    # Users
    # Search route must have :get and :post or will_paginate will
    # not work properly.
    match '/users/search', to: 'users#search', via: [:get, :post]
    resources :users

    # Skip Devise controllers we override and want to handle ourselves.
    devise_for :users, skip: [:confirmations, :registrations, :sessions]
    devise_for :users, controllers: {
      # Add routes for Devise controllers we override and want to handle
      # ourselves here.
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }

    # Error handling routes
    match '/401', to: 'errors#unauthorized', via: :all, as: :unauthorized_error
    match '/404', to: 'errors#not_found', via: :all, as: :not_found_error
    match '/406', to: 'errors#not_acceptable', via: :all, as: :not_acceptable_error
    match '/500', to: 'errors#internal_server_error', via: :all, as: :internal_server_error

    root 'home#index'
  end

end

Rails.application.routes.draw do

  scope "(:locale)" do

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

    # Users
    resources :users
    post '/users/search' => 'users#search', as: :user_search

    # Error handling routes
    match '/401' => 'errors#unauthorized', via: :all, as: :unauthorized_error
    match '/404' => 'errors#not_found', via: :all, as: :not_found_error
    match '/406' => 'errors#not_acceptable', via: :all, as: :not_acceptable_error
    match '/500' => 'errors#internal_server_error', via: :all, as: :internal_server_error

    root 'home#index'
  end

end

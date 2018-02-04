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

  resources :users

  match '/401' => 'errors#unauthorized', via: :all
  match '/404' => 'errors#not_found', via: :all
  match '/406' => 'errors#not_acceptable', via: :all
  match '/500' => 'errors#internal_server_error', via: :all

  root 'home#index'
end

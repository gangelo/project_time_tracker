Rails.application.routes.draw do
  scope "(:locale)" do
    # Skip Devise controllers we override and want to handle ourselves.
    devise_for :users, skip: [:confirmations, :registrations, :sessions, :passwords]
    devise_for :users, controllers: {
      # Add routes for Devise controllers we override and want to handle
      # ourselves here.
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
      # passwords: 'users/passwords'
    }

    # Users
    # Search route must have :get and :post or will_paginate will
    # not work properly.
    match '/users/search', to: 'users#search', via: [:get, :post]
    resources :users

    get 'dashboard/index'
    post 'dashboard/start_task/:id', to: 'dashboard#start_task',
      as: :dashboard_start_task
    post 'dashboard/stop_task/:id', to: 'dashboard#stop_task',
      as: :dashboard_stop_task
    get 'dashboard/edit_note/:id', to: 'dashboard#edit_note',
      as: :dashboard_edit_note
    patch 'dashboard/update_note/:id', to: 'dashboard#update_note',
      as: :dashboard_update_note
    get 'dashboard/new_task_time', to: 'dashboard#new_task_time',
      as: :dashboard_new_task_time
    post 'dashboard/create_task_time', to: 'dashboard#create_task_time',
      as: :dashboard_create_task_time
    get 'dashboard/companies.json', to: 'dashboard#companies',
      as: :dashboard_companies
    get 'dashboard/projects.json', to: 'dashboard#projects',
      as: :dashboard_projects
    get 'dashboard/tasks.json', to: 'dashboard#tasks',
      as: :dashboard_tasks
    get 'dashboard/edit_duration/:id', to: 'dashboard#edit_duration',
      as: :dashboard_edit_duration
    patch 'dashboard/update_duration/:id', to: 'dashboard#update_duration',
      as: :dashboard_update_duration

    # Error handling routes
    match '/401', to: 'errors#unauthorized', via: :all, as: :unauthorized_error
    match '/404', to: 'errors#not_found', via: :all, as: :not_found_error
    match '/406', to: 'errors#not_acceptable', via: :all, as: :not_acceptable_error
    match '/500', to: 'errors#internal_server_error', via: :all, as: :internal_server_error

    root 'home#index'
  end

end

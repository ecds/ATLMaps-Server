# frozen_string_literal: true

# config/routes.rb

Rails.application.routes.draw do
  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :users
    get 'users/me', to: 'users#me'
    resources :categories
    resources :tags
    resources :institutions
    resources :logins
    resources :projects
    resources :raster_layers, path: 'raster-layers' do
      get :thumbnail, on: :member
    end

    resources :raster_layer_projects, path: 'raster-layer-projects'
    resources :users
    resources :vector_layers, path: 'vector-layers'
    resources :vector_layer_projects, path: 'vector-layer-projects'
    resources :vector_features, path: 'vector-features'
    resources :year_ranges, path: 'year-ranges'
    resources :confirmation_tokens, path: 'confirmation-tokens'

    get 'raster_layers'
  end

  post 'uploads/vector/parse', to: 'uploads/vector#parse'
  post 'uploads/vector/preview', to: 'uploads/vector#preview'
  post 'uploads/vector/new', to: 'uploads/vector#new'

  # Additional version for testing
  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :projects, only: :index
  end

  mount EcdsRailsAuthEngine::Engine, at: '/auth'
end

Rails.application.routes.draw do
  
  use_doorkeeper do
    # Using a custom controller for the token response so we can
    # inject a user's details.
    controllers :tokens => 'custom_tokens'
  end
  
  devise_for :users
  
  namespace :api, path: '/', constraints: { subdomain: 'api' } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    namespace :v1 do
      
      with_options only: [:index, :show] do |list_show|
        list_show.resources :layers
        list_show.resources :raster_layers, :path => "rasterLayers"
        list_show.resources :vector_layers, :path => "vectorLayers"
        list_show.resources :tags
        list_show.resources :institutions
        list_show.resources :users
      end
      
      with_options only: [:index, :show, :create, :destroy, :update] do |crud|
        crud.resources :projects
        crud.resources :projectlayers
        crud.resources :raster_layer_projects, :path => "rasterLayerProjects"
        crud.resources :vector_layer_projects, :path => "vectorLayerProjects"
        crud.resources :collaborations
      end
      
    end
  end
  get "/users/sign_up" => "users#new"
  get "/users/sign_in" => "devise/sessions#new"
  post "/user" => "users#create"
  post "/users/sign_in" => "devise/sessions#create"
  delete "/users/sign_out" => "devise/sessions#destroy"

  root to: "home#index"
end


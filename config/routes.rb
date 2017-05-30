Rails.application.routes.draw do
    # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    namespace :api, path: '/', constraints: { subdomain: 'api' } do
        namespace :v1 do
            with_options only: [:index, :show] do |list_show|
                list_show.resources :layers
                # list_show.resources :raster_layers, :path => "rasterLayers"
                list_show.resources :tags
                list_show.resources :institutions
                list_show.resources :categories
                list_show.resources :year_ranges, path: 'year-ranges'
                list_show.resources :map_layers
                list_show.resources :vector_features, path: 'vector-features'
            end

            with_options only: [:index, :show, :create, :destroy, :update] do |crud|
                crud.resources :projects
                # crud.resources :projectlayers
                crud.resources :raster_layer_projects, path: 'raster-layer-projects'
                crud.resources :vector_layer_projects, path: 'vector-layer-projects'
                crud.resources :vector_layers, path: 'vector-layers'
                crud.resources :collaborations
                crud.resources :logins
            end

            with_options only: [:index, :show, :update, :create] do |add_update|
                add_update.resources :users
                add_update.resources :raster_layers, path: 'raster-layers'
            end

            with_options only: [:create, :index] do |only_create|
                only_create.resources :user_taggeds, path: 'user-taggeds'
            end

            with_options only: [:show, :index] do |only_update|
                only_update.resources :confirmation_tokens, path: 'confirmation-tokens'
            end
        end
    end

    post '/v1/token', to: 'oauth2#create'
    post '/v1/revoke', to: 'oauth2#destroy'

    # root to: redirect('/admin')
end

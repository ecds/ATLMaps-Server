Rails.application.routes.draw do
    # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    # devise_for :users

    namespace :api, path: '/', constraints: { subdomain: 'api' } do
        namespace :v1 do
            get '/users/me' => 'users#me'

            with_options only: [:index, :show] do |list_show|
                list_show.resources :layers
                # list_show.resources :raster_layers, :path => "rasterLayers"
                list_show.resources :vector_layers, path: 'vectorLayers'
                list_show.resources :tags
                list_show.resources :institutions
                list_show.resources :users
                list_show.resources :searches
                list_show.resources :categories
                list_show.resources :year_ranges, path: 'yearRanges'
                list_show.resources :map_layers
            end

            with_options only: [:index, :show, :create, :destroy, :update] do |crud|
                crud.resources :projects
                # crud.resources :projectlayers
                crud.resources :raster_layer_projects, path: 'rasterLayerProjects'
                crud.resources :vector_layer_projects, path: 'vectorLayerProjects'
                crud.resources :collaborations
                crud.resources :logins
            end

            with_options only: [:index, :show, :update, :create] do |add_update|
                add_update.resources :raster_layers, path: 'rasterLayers'
            end

            with_options only: [:create, :index] do |only_create|
                only_create.resources :user_taggeds, path: 'userTaggeds'
            end
        end
    end

    # get '/users/sign_up' => 'users#new'
    # get '/users/sign_in' => 'devise/sessions#new'
    # post '/user' => 'users#create'
    # post '/users/sign_in' => 'devise/sessions#create'
    # # match "/searches" => "searches#index", via: [:get, :post]
    # delete '/users/sign_out' => 'devise/sessions#destroy'

    post '/v1/token', to: 'oauth2#create'
    post '/v1/revoke', to: 'oauth2#destroy'

    # root to: redirect('/admin')
end

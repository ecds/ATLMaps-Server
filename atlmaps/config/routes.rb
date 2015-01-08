Rails.application.routes.draw do
  
  use_doorkeeper
  
  devise_for :users
  
  namespace :api, path: '/', constraints: { subdomain: 'api' } do
    namespace :v1 do
      resources :layers, only: [:index, :show]
      resources :projects#, defaults => { :format => 'json' }
      resources :projectlayers, only: [:index, :show, :create, :destroy]
      
      get '/tokens/me' => "tokens#me"
      
      #with_options only: :index do |list_only|
      #  list_only.resources :zombies
      #  list_only.resources :humans
      #  list_only.resources :medical_kits
      #end
      
    end
  end
  get "/users/sign_up" => "users#new"
  post "/user" => "users#create"

  root to: "home#index"
end


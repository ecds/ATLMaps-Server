Rails.application.routes.draw do
  
  namespace :api, path: '/', constraints: { subdomain: 'api' } do
    namespace :v1 do
      resources :layers, only: [:index, :show]
      resources :projects#, defaults => { :format => 'json' }
      resources :projectlayers, only: [:index, :show, :create, :destroy]
      
      #with_options only: :index do |list_only|
      #  list_only.resources :zombies
      #  list_only.resources :humans
      #  list_only.resources :medical_kits
      #end
      
    end
  end
end


Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchant_search#show'
      get 'items/find_all', to: 'item_search#index'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
      resources :items, except: [:new] do
        resources :merchant, only: [:index], controller: 'items/merchant'
      end
    end
  end
end

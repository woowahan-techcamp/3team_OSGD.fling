Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :recipes
  resources :products
  get '/get_products/:id', to: 'recipes#get_products'
  get '/season', to: 'recipes#season'
  post '/search_product', to: 'products#search'
  post '/get_products', to: 'products#get_products'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

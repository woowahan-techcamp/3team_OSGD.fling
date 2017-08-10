Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :recipes
  get '/get_products/:id', to: 'recipes#get_products'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :recipes
  get '/get_material/:id', to: 'recipes#get_material'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

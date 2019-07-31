Rails.application.routes.draw do
  # resources :distances
  # resources :maps
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'distance/:map/:origin/:destiny/:cost', to: 'distance#index'
  post 'distance/:map', to: 'distance#update'
end

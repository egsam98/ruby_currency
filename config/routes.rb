Rails.application.routes.draw do
  resources :currency, only: [:show]
end

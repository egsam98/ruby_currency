Rails.application.routes.draw do
  resources :currency, only: [:show]
  # get 'currency/:id', to: "currency#show"
end

Rails.application.routes.draw do
  namespace :api do
    resources :currencies, only: [:show]
  end
  match "*path" => "application#routing_error", via: :all
end

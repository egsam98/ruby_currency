Rails.application.routes.draw do
  resources :currencies, only: [:show]
  match "*path" => "application#routing_error", via: :all
end

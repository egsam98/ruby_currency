Rails.application.routes.draw do
  get '/' => redirect('/api-docs')
  get '/api-docs' => "docs#index"
  namespace :api do
    resources :currencies, only: [:show]
  end
  match "*path" => "application#routing_error", via: :all
end

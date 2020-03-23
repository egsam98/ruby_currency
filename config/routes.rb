Rails.application.routes.draw do
  get '/api-docs' => "application#api_docs"
  get '/' => redirect('/api-docs')
  namespace :api do
    resources :currencies, only: [:show]
  end
  match "*path" => "application#routing_error", via: :all
end

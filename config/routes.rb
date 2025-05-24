Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post '/login', to: 'session#create'
  post '/signup', to: 'session#signup'

  get '/profile', to: 'users#profile'

  resources :chatrooms, only: [:index, :show, :create] do
    # resources :messages
  end

  get '*path', to: 'static#index', constraints: ->(req) { !req.xhr? && req.format.html? }

  mount ActionCable.server => '/cable'
end

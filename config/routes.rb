Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/articles/:id', to: 'articles#show'
      get '/articles/', to: 'articles#index'
      delete '/articles/:id', to: 'articles#destroy'
    end
  end
end
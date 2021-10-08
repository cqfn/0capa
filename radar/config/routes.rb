Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :webhook, only: [:index, :show, :create]
    end
  end
end

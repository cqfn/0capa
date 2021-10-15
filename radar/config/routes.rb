# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :webhook, only: %i[index create delete destroy]
    end
  end
end
# Rails.application.routes.draw do
#   namespace :api do
#     namespace :v1 do
#       resources :webhook, only: [:index, :show, :create]
#     end
#   end
# end

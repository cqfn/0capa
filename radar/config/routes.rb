# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :webhook, only: %i[index show create]
    end
  end
end

# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :issues, only: [:create]
      post "update_issue", to: "issues#update_issue"
    end
  end
end

# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :issues, only: [:create]
      post "update_issue", to: "issues#update_issue"
      post "create_issue", to: "issues#create_github_issues"
    end
  end
end

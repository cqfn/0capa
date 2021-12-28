# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "radar/create"
    end
  end
  namespace :api do
    namespace :v1 do
      resources :webhook, only: %i[index create destroy]
      resources :notications_handler, only: %i[index create destroy]
      get "invitations", to: "notications_handler#check_invitations"
      get "repos_update", to: "radar#check_repos_update"
      post "code-scanner", to: "webhook#CodeScanner"
      post "code-scanner-hook", to: "webhook#CodeScannerHook"
    end
  end
  namespace :web do
    get "/", to: "tom_report#index"
  end
end

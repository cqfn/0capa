# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :webhook, only: %i[index create destroy]
      post "code-scanner", to: "webhook#CodeScanner"
      post "code-scanner-hook", to: "webhook#CodeScannerHook"
    end
  end
  namespace :web do
    get "/", to: "tom_report#index"
  end
end

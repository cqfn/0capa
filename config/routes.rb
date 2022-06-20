# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :api do
    get "endpoint/start"
    get "endpoint/stop"
    # ML Advidor endpoints
    namespace :advisor do
      namespace :v1 do
        get "train-model", to: "advisor#train"
        post "start-advisor", to: "advisor#start_advisor"
        post "stop-advisor", to: "advisor#stop_advisor"
      end
    end
    # Chatbot endpoints
    namespace :chatbot do
      namespace :v1 do
        resources :issues, only: [:create]
        post "update_issue", to: "issues#update_issue"
        post "create_issue", to: "issues#create_github_issues"
      end
    end
    namespace :radar do
      namespace :v1 do
        # radar endpoints
        resources :webhook, only: %i[index create destroy]
        resources :notications_handler, only: %i[index create destroy]
        get "radar_hostname", to: "radar#get_host"
        get "radar_repos_json", to: "radar#repos_from_json"
        post "start-radar", to: "radar#start_radar"
        post "stop-radar", to: "radar#stop_radar"
      end
    end
  end
  namespace :web do
    get "/", to: "tom_report#index"
  end
end

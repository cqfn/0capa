# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :export do
      namespace :v1 do
        get 'repo_stats', to: 'repo_stats#export'
      end
    end
  end
  root 'report#index'
  namespace :api do
    get 'endpoint/start'
    get 'endpoint/stop'
    namespace :admin do
      namespace :v1 do
        post 'add_pattern', to: 'index#add_pattern'
        post 'add_capa', to: 'index#add_capa'
      end
    end
    # ML Advisor endpoints
    namespace :advisor do
      namespace :v1 do
        get 'train-model', to: 'advisor#train'
        post 'start-advisor', to: 'advisor#start_advisor'
        post 'stop-advisor', to: 'advisor#stop_advisor'
      end
    end
    # Chat bot endpoints
    namespace :chatbot do
      namespace :v1 do
        resources :issues, only: [:create]
        resource :github_webhooks, only: :create, defaults: { formats: :json }
        get 'setup_webhook', to: 'setup_webhook#index'
        post 'update_issue', to: 'issues#update_issue'
        post 'create_issue', to: 'issues#create_github_issues'
        post 'start-chatbot', to: 'chatbot#start_chatbot'
        post 'stop-chatbot', to: 'chatbot#stop_chatbot'
      end
    end
    namespace :radar do
      namespace :v1 do
        # radar endpoints
        resources :webhook, only: %i[index create destroy]
        resources :notications_handler, only: %i[index create destroy]
        get 'radar_hostname', to: 'radar#get_host'
        get 'radar_repos_json', to: 'radar#repos_from_json'
        post 'start-radar', to: 'radar#start_radar'
        post 'stop-radar', to: 'radar#stop_radar'
      end
    end
    namespace :oauth do
      namespace :v1 do
        get 'github', to: 'github#index'
      end
    end
  end
end

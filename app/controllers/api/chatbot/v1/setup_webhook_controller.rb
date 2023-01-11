# frozen_string_literal: true

include ActionController::Cookies

require 'http'
require 'json'

module Api
  module Chatbot
    module V1
      class SetupWebhookController < ApplicationController
        def initialize
          puts 'initialize SetupGithubWebhookController controller'
        end

        def index
          project_id = params[:project_id]
          project = TomProject.find(project_id.to_i)

          if project.source == 'github'
            puts 'Github WebHook'
            hook = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "Bearer #{cookies[:github_token]}"].post(
              "#{project.repo_url}/hooks", json: { name: 'web', active: true, events: ['issue_comment'],
                                                   config: { url: 'https://0capa.ru/api/chatbot/v1/github_webhooks', content_type: 'json', insecure_ssl: '0', secret: 'GITHUB_WEBHOOK_SECRET' } }
            )
            project.webhook_active = 'Y'
            project.save
          else
            puts 'Unsupported source'
          end

          redirect_to controller: '/report'
        end
      end
    end
  end
end

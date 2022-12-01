# frozen_string_literal: true

module Api
  module Chatbot
    module V1
      class GithubWebhooksController < ActionController::Base
        skip_forgery_protection
        include GithubWebhook::Processor

        # Handle issue comment event
        def github_issue_comment(payload)
          return unless payload['action'] == "created"

          if payload['comment']['body'].match(/switch/)
            if payload['comment']['body'].match(/Random/)
              puts 'скорее всего нас попросили свитчнуться в рандом мод'

            elsif payload['comment']['body'].match(/ML/)
              puts 'скорее всего нас попросили свитчнуться в мл мод'

            end
          end
        end

        private

        def webhook_secret(payload)
          'GITHUB_WEBHOOK_SECRET'
        end
      end
    end
  end
end
# frozen_string_literal: true

module Api
  module Chatbot
    module V1
      class ChatbotController < ApplicationController
        @@Tokens = nil
        @@call_count = 0
        @@External_threar_stop = false
        @@Is_active_instance = false
        SOURCE = 'github'

        def initialize
          puts 'initialize ChatBot controller'
          get_tokens
        end

        def get_tokens
          puts 'Getting token list..'
          @@Tokens = TomTokensQueue.where(source: 'github')
        end

        def start_chatbot
          puts 'initializing chatbot...'
          @@External_threar_stop = false
          if @@Is_active_instance == false
            puts 'there is no active instance, setting up a new one...'
            @@Is_active_instance = true
            GenerateCapasJob.perform_later
          else
            puts 'there is already an instance running...'
            false
          end
        end

        def stop_chatbot
          @@External_threar_stop = true
          puts 'signal stop sent...'
        end
      end
    end
  end
end

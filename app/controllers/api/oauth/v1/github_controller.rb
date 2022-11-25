include ActionController::Cookies

module Api
  module Oauth
    module V1
      class GithubController < ApplicationController
        def initialize
          puts 'initialize GitHub controller'
        end

        def index
          settings = TomSetting.find_by(agentname: 'github_oauth')
          code = params[:code]
          response = HTTP[accept: 'application/json'].post('https://github.com/login/oauth/access_token', json: {
            client_id: settings.apikey,
            client_secret: settings.apisecret,
            code: code
          })

          if response.code == 200
            json = JSON.parse(response)

            if json['access_token'] != nil
              cookies[:github_token] = {
                :value => json['access_token'],
                :expires => 1.year.from_now,
                :domain => '0capa.ru'
              }
            else
              print('Error getting token ')
              puts JSON.pretty_generate(response.parse)
            end
          else
            print('Error getting token ')
            puts JSON.pretty_generate(response.parse)
          end

          redirect_to controller: "/report"
        end
      end
    end
  end
end
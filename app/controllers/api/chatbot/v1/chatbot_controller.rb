# frozen_string_literal: true
#
# Паттерн 5 - капа 0
# Паттерн 11 - капа 1
# Паттерн 12 - капа 0
# Паттерн 13 - капа 0
# Паттерн 14 - капа 1

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
            loop do
              puts 'Processing repos...'
              TomProject.where('source = :source', {
                source: SOURCE,
              }).first(5).each do |project|
                capa(project.repo_url)
                sleep(60)
              end
              sleep(2.hours)
              next unless @@External_threar_stop == true
              puts 'signal stop catched...'
              @@Is_active_instance = false
              return true
            end
          else
            puts 'there is already an instance running...'
            false
          end
        end

        def capa(request_url)
          capas = [
            'review and improve staff training procedures [#TOM-C001]',
            'replan project and re-estimate targets [#TOM-C002]',
            'review and improve estimating procedures [#TOM-C003]',
            'review and improve project working procedures [#TOM-C004]',
            'if the scope of the project has been underestimated, obtain more experienced staff [#TOM-C005]',
            'if the scope has been overestimated, release experienced staff to other projects [#TOM-C006]',
            'stop current work and revert to activities of preceding stage [#TOM-C007]',
            'extend activities of previous stage into current stage, replanning effort and work assignment [#TOM-C008]',
            'extend timescales for testing and debugging current stage because of anticipated additional latent faults from previous stage [#TOM-C009]',
            'review and improve criteria for entry to, and exit from, stages and activities [#TOM-C010]',
            'redesign the module into smaller components [#TOM-C011]',
            'extend the timescales for testing the module [#TOM-C012]'
          ]
          issue_body = if $capas_mode == "Random"
            "💫TOM has finished to check you code and it would like to advise you with some actions:
            - #{capas.sample}"
          else
            "💫TOM has finished to check you code and it would like to advise you with some actions:
            - #{GeneratedCapa.where(status: 'N').first.body}"
                       end
          capaResponse = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{getNextToken}"].post(
            "#{request_url}/issues", json: { title: '🦥Capa suggestion', body: issue_body }
          )
          puts JSON.pretty_generate(capaResponse.parse)
        end

        def stop_chatbot
          @@External_threar_stop = true
          puts 'signal stop sent...'
        end

        def welcome_issue
          issue_body = 'some-body'

          response = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{getNextToken}"].post(
            'https://api.github.com/repos/xavzelada/repo_test/issues', json: { title: 'Welcome issue over repo',
                                                                               body: 'some body' }
          )

          if response.code == 201
            render json: { message: 'Call caught' }, status: 200
          else
            puts 'Error creating an ticket'
            puts JSON.pretty_generate(response.parse)
            render json: { message: 'Something went wrong' }, status: 404
          end
        end

        def create
          puts 'Working..'
          settings = TomSetting.find_by(agentname: 'github')
          TomRadarActivation.where(status: 'Pending').each do |activation|
            puts activation.id
            response = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{getNextToken}"].post(
              'https://api.github.com/repos/xavzelada/repo_test/issues', json: { title: activation.issuetitle,
                                                                                 body: activation.issuebody }
            )
            puts JSON.pretty_generate(response)
            if response.code == 201
              activation.status = 'Success'
              activation.save

              json = JSON.parse(response)

              myIssue = TomIssue.new(
                issueid: json['id'],
                repo_issueid: json['number'],
                created_at_ext: json['created_at']
              )
              myIssue.save
            else
              print('Error creating an ticket')
              puts JSON.pretty_generate(response.parse)
            end
            puts response
          end

          render json: { message: 'Posting issues finished' }, status: 200
        end

        def update_issue
          request.body.rewind
          json = JSON.parse(
            case request.content_type
            when 'application/x-www-form-urlencoded'
              params[:payload]
            when 'application/json'
              request.body.read
            else
              raise "Invalid content-type: \"#{request.content_type}\""
            end
          )
          if json['action'] == 'closed'
            myIssue = TomIssue.find_by(issueid: json['issue']['id'])
            myIssue.comments = json['issue']['comments']
            # myIssue.closed_by = json["issue"]["comments"]
            myIssue.closed_at_ext = json['issue']['closed_at']
            if myIssue.save
              render json: { message: 'Call caught' }, status: 201
            else
              render json: { error: 'Error processing the data' }, status: 400
            end
          else
            render json: { message: 'Action no tracker' }, status: 201
          end
        rescue Exception => e
          render json: { error: e.message }, status: 422
        end

        def create_github_issues
          settings = TomSetting.find_by(agentname: 'github')

          TomProjectCapaPrediction.where(status: 'N').each do |prediction|
            # posted
            # prediction.status = "P"
            puts prediction.id

            info_url_template = settings.issues_info_url.dup

            request_url = info_url_template.sub! '#repo_fullname', prediction.repo_fullname

            issue_body = 'TOM has finished to check you code and it would like to advise you with some actions:'

            capas = TomCapaDictonary.where(case_id: prediction.label).each do |capa|
              issue_body = "#{issue_body}
  - #{capa.description}"
            end

            puts issue_body
            prediction.save
            response = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{getNextToken}"].post(
              request_url, json: { title: "TOM Findings over repo ##{prediction.repo_fullname}",
                                   body: issue_body }
            )

            puts JSON.pretty_generate(response)

            if response.code == 201
              prediction.status = 'P'
              prediction.save

              json = JSON.parse(response)

              myIssue = TomIssue.new(
                issueid: json['id'],
                repo_issueid: json['number'],
                created_at_ext: json['created_at']
              )

              myIssue.save
            else
              print('Error creating an ticket')
              puts JSON.pretty_generate(response.parse)
            end
            puts response
          end

          render json: { message: 'Posting issues finished' }, status: 200
        end

        def getNextToken
          @@call_count += 1
          next_token_index = (@@call_count % @@Tokens.length)
          @@Tokens[next_token_index].token
        end

        def getQueueCounter
          project_count = TomProject.where('source = :source', {
                                             source: SOURCE
                                           }).count
          puts "project_count -> #{project_count}"
          project_count
        end
        
      end
    end
  end
end

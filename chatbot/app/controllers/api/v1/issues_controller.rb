# frozen_string_literal: true

require "http"
require "json"

module Api
  module V1
    class IssuesController < ApplicationController
      skip_before_action :verify_authenticity_token
      @base_uri = "https://api.github.com/repos/xavzelada/repo_test/issues"

      def create
        settings = TomSetting.find_by(agentname: "github")

        TomRadarActivation.where(status: "Pending").each do |activation|
          puts activation.id
          response = HTTP[accept: "application/vnd.github.v3+json", Authorization: "token #{settings.apisecret}"].post(
            "https://api.github.com/repos/xavzelada/repo_test/issues", json: { title: activation.issuetitle,
                                                                               body: activation.issuebody },
          )
          puts JSON.pretty_generate(response)
          if response.code == 201
            activation.status = "Success"
            activation.save

            json = JSON.parse(response)

            myIssue = TomIssue.new(
              issueid: json["id"],
              repo_issueid: json["number"],
              created_at_ext: json["created_at"],
            )

            myIssue.save
          else
            print("Error creating an ticket")
            puts JSON.pretty_generate(response.parse)
          end
          # puts response
        end

        render json: { message: "Posting issues finished" }, status: 200
      end

      def update_issue
        begin
          request.body.rewind
          json = JSON.parse(
            case request.content_type
            when "application/x-www-form-urlencoded"
              params[:payload]
            when "application/json"
              request.body.read
            else
              raise "Invalid content-type: \"#{request.content_type}\""
            end
          )
          if json["action"] == "closed"
            myIssue = TomIssue.find_by(issueid: json["issue"]["id"])
            myIssue.comments = json["issue"]["comments"]
            # myIssue.closed_by = json["issue"]["comments"]
            myIssue.closed_at_ext = json["issue"]["closed_at"]
            if myIssue.save
              render json: { message: "Call catched" }, status: 201
            else
              render json: { error: "Error processing the data" }, status: 400
            end
          else
            render json: { message: "Action no tracker" }, status: 201
          end
        rescue Exception => e
          render json: { error: e.message }, status: 422
        end
      end
    end
  end
end

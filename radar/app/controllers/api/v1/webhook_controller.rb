# frozen_string_literal: true

require_rel "../../radar/"

module Api
  module V1
    # Controller to handle webhook calls
    class WebhookController < ApplicationController
      # skip_before_action :verify_authenticity_token

      def index
        render json: { message: "This URL expects POST requests from a code hub platform WebHook." }, status: 200
      end

      def create
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

          radar_name = params[:source].capitalize
          myRadar = RadarFactoryClass.create("#{radar_name}Radar", nil)
          if myRadar.get_last_update(json)
            render json: { message: "Call catched" }, status: 201
          else
            render json: { error: "Error Fetching the data" }, status: 400
          end
        rescue Exception => e
          render json: { radar: radar_name, error: e.message }, status: 422
        end
      end

      def destroy
        if params[:testing]
          TomRadarActivation.destroy_all()
          render json: { message: "Activations deleted - only for testing purposes" }, status: 204
        else
          render json: { error: "Operation not allowed" }, status: 403
        end
      end
    end
  end
end

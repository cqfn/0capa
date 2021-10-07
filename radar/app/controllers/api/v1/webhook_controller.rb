class Api::V1::WebhookController < ApplicationController
  def index
    render json: {message: "This URL expects POST requests from a code hub platform WebHook."}, status: 200
  end

  def create

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

    activation = TomRadarActivation.new(
      source: params[:source],
      issuetitle: "TOM Issue",
      issuebody: "This issue was created automatically by TOM",
      status: "Pending",
    )
    if activation.save
      render json: {message: "Call catched"}, status: 200
    else
      render json: {error: "Error creation entity"}, status: 400
    end

  end
end

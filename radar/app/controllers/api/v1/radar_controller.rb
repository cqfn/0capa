# frozen_string_literal: true

require_rel "../../radar/"
# Controller to handle github notifications
class Api::V1::RadarController < ApplicationController
  def check_repos_update
    radar_name = params[:source].capitalize
    radar = FactoryClass.create("#{radar_name}Radar", nil)
    if radar.check_repos_update()
      render json: { message: "Call catched" }, status: 200
    else
      render json: { error: "Error Fetching the data" }, status: 400
    end
  end
end

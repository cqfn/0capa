# frozen_string_literal: true

require_rel "../../../radar/"
require "socket"
# Controller to handle github notifications
class Api::Radar::V1::RadarController < ApplicationController
  # def check_repos_update
  #   radar_name = params[:source].capitalize
  #   radar = FactoryClass.create("#{radar_name}Radar", nil)
  #   if radar.check_repos_update()
  #     render json: { message: "Call catched" }, status: 200
  #   else
  #     render json: { error: "Error Fetching the data" }, status: 400
  #   end
  # end

  # def repos_full_update
  #   radar_name = params[:source].capitalize
  #   radar = FactoryClass.create("#{radar_name}Radar", nil)
  #   if radar.get_repos_full_update()
  #     render json: { message: "Call catched" }, status: 200
  #   else
  #     render json: { error: "Error Fetching the data" }, status: 400
  #   end
  # end

  def repos_from_json
    radar_name = params[:source].capitalize
    query = params[:query_url]
    radar = FactoryClass.create("#{radar_name}Radar", nil)
    if radar.get_repos_from_query(query)
      render json: { message: "Call catched" }, status: 200
    else
      render json: { error: "Error Fetching the data" }, status: 400
    end
  end

  def start_radar
    host = Socket.gethostname + "-" + Thread.current.object_id.to_s
    puts "host -> " + host
    radar_name = params[:source].capitalize
    radar = FactoryClass.create("#{radar_name}Radar", nil)

    radar.async.start_radar

    render json: { message: "Call catched" }, status: 200
  end

  def stop_radar
    @@External_threar_stop = true
    host = Socket.gethostname + "-" + Thread.current.object_id.to_s
    puts "host -> " + host
    radar_name = params[:source].capitalize
    radar = FactoryClass.create("#{radar_name}Radar", nil)

    radar.async.stop_radar

    render json: { message: "Call catched" }, status: 200
  end

  def get_host
    render json: { host: Socket.gethostname }
  end
end

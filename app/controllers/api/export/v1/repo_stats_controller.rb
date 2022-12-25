class Api::Export::V1::RepoStatsController < ApplicationController
  def export
    puts params[:url]

    send_data GeneratedCapa.to_csv(params[:url]), filename: "generated-capas-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv"
  end
end

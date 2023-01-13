# frozen_string_literal: true

module Api
  module Export
    module V1
      class RepoStatsController < ApplicationController
        def export
          puts params[:url]

          send_data GeneratedCapa.to_csv(params[:url]),
                    filename: "generated-capas-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv"
        end

        def export_all
          send_data GeneratedCapa.all_to_csv,
                    filename: "generated-capas-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv"
        end
      end
    end
  end
end

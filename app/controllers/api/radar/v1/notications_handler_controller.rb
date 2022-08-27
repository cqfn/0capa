# frozen_string_literal: true

require_rel '../../../radar/'
# Controller to handle github notifications
module Api
  module Radar
    module V1
      class NoticationsHandlerController < ApplicationController
        def check_invitations
          radar_name = params[:source].capitalize
          radar = FactoryClass.create("#{radar_name}Radar", nil)
          if radar.check_new_invitations
            render json: { message: 'Call catched' }, status: 200
          else
            render json: { error: 'Error Fetching the data' }, status: 400
          end
        end
      end
    end
  end
end

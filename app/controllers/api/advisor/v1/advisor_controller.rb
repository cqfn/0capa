# frozen_string_literal: true

require_rel '../../../ml_model/'

module Api
  module Advisor
    module V1
      class AdvisorController < ApplicationController
        def train
          model_name = params[:model].capitalize
          ml_model = FactoryClass.create("#{model_name}Model", nil)
          ml_model.async.train

          render json: { message: 'Call catched' }, status: 200
        end

        def start_advisor
          model_name = params[:model].capitalize
          ml_model = FactoryClass.create("#{model_name}Model", nil)
          ml_model.async.start_advisor

          render json: { message: 'Call catched' }, status: 200
        end

        def stop_advisor
          model_name = params[:model].capitalize
          ml_model = FactoryClass.create("#{model_name}Model", nil)
          ml_model.async.stop_advisor

          render json: { message: 'Call catched' }, status: 200
        end
      end
    end
  end
end

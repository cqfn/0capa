# frozen_string_literal: true

module Api
  module Admin
    module V1
      class IndexController < ApplicationController
        def add_pattern
          @@consensus_pattern = params[:pattern]
          @@window = params[:window]
          @@title = params[:title]
          @@threshold = params[:threshold]
          @@metrics = params[:metrics]
          pattern = Pattern.new(
            title: @@title,
            window: @@window.to_i,
            threshold: @@threshold.to_f,
            consensus_pattern: @@consensus_pattern.split(',').map { |x| x.strip.to_f },
            metrics: @@metrics
          )
          pattern.save
          puts pattern.inspect

          redirect_to controller: '/report', anchor: 'success-pattern'
        end

        def add_capa
          @@title = params[:title]
          @@description = params[:description]
          @@pattern = params[:pattern]

          capa = Capa.new(
            title: @@title,
            description: @@description,
            pattern_id: Pattern.where(title: @@pattern).first.id
          )
          capa.save
          puts capa.inspect

          redirect_to controller: '/report', anchor: 'success-capa'
        end
      end
    end
  end
end

# frozen_string_literal: true

require_rel '../scheduler/'

module Api
  class EndpointController < ApplicationController
    def start
      manager = SchedulerManager.new
      manager.async.start_process
      # manager.async.start_process2()
      # manager.async.start_process2()
    rescue StandardError => e
      puts e
      ''
    end

    def stop
      manager = SchedulerManager.new
      manager.stop_process
    rescue StandardError => e
      puts e
      ''
    end
  end
end

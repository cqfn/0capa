require_rel "../scheduler/"

class Api::EndpointController < ApplicationController
  def start
    manager = SchedulerManager.new
    manager.async.start_process()
    # manager.async.start_process2()
    # manager.async.start_process2()
  rescue => e
    puts e
    return ""
  end

  def stop
    manager = SchedulerManager.new
    manager.stop_process()
  rescue => e
    puts e
    return ""
  end
end

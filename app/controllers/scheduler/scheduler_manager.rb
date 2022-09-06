# frozen_string_literal: true

require 'celluloid'
# require "celluloid/autostart"
# require "celluloid/pool"
require_relative 'scheduler_worker'

class SchedulerManager
  include Celluloid
  @@External_threar_stop = false

  def stop_process
    @@External_threar_stop = true
  end

  def start_process
    puts 'Manager 1 started'
    @@External_threar_stop = false
    worker_pool = SchedulerWorker.pool(size: 2)
    # while true
    _limit = 10
    [*1.._limit].each do |p|
      _time = rand(10..15)
      puts "before worker starts, time-> #{_time}"
      worker_pool.async.process(p, _time, 1)
      worker_pool.async.process2(p, _time, 1)
      puts 'after worker starts'
    end
    #   if @@External_threar_stop == true
    #     break
    #   end
    # end
  end

  def start_process2
    puts 'Manager 2 started'
    # @@External_threar_stop = false
    # while true

    # if @@External_threar_stop == true
    #     break
    #   end

    # end

    worker_pool = SchedulerWorker.pool(size: 2)

    [*1..10].each do |p|
      _time = rand(10..15)
      puts "before worker 2 starts, time-> #{_time}"
      worker_pool.async.process(p, _time, 2)
      puts 'after worker 2 starts'
    end
  end
end

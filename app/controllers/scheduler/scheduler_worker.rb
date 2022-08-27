# frozen_string_literal: true

require 'celluloid'
require 'celluloid/autostart'
require 'celluloid/pool'

class SchedulerWorker
  include Celluloid

  def process(param, time, w_id)
    puts "worker #{w_id} process 1 started -> #{param}, time-> #{time}, running on thread -> #{Thread.current.object_id}"
    # after(time) {
    #   puts "worker finished -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
    # }
    sleep(time)
    puts "worker #{w_id} process 1 finished -> #{param}, time-> #{time}, running on thread -> #{Thread.current.object_id}"
  end

  def process2(param, time, w_id)
    puts "worker #{w_id} process 2 started -> #{param}, time-> #{time}, running on thread -> #{Thread.current.object_id}"
    # after(time) {
    #   puts "worker finished -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
    # }
    sleep(time)
    puts "worker #{w_id} process 2 finished -> #{param}, time-> #{time}, running on thread -> #{Thread.current.object_id}"
  end

  # def async_process(pool_size)
  #   worker_pool = SchedulerWorker.pool(size: pool_size)

  #   [*1..20].each do |p|
  #     _time = rand(10..15)
  #     puts "before worker starts"
  #     worker_pool.async.process(p, _time)
  #     puts "after worker starts"
  #   end
  # end
end

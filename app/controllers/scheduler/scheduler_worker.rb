require "celluloid"
require "celluloid/autostart"
require "celluloid/pool"

class SchedulerWorker
  include Celluloid

  def process(param, time, w_id)
    puts "worker " + w_id.to_s + " process 1 started -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
    # after(time) {
    #   puts "worker finished -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
    # }
    sleep(time)
    puts "worker " + w_id.to_s + " process 1 finished -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
  end

  def process2(param, time, w_id)
    puts "worker " + w_id.to_s + " process 2 started -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
    # after(time) {
    #   puts "worker finished -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
    # }
    sleep(time)
    puts "worker " + w_id.to_s + " process 2 finished -> " + param.to_s + ", time-> " + time.to_s + ", running on thread -> " + Thread.current.object_id.to_s
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

require 'json'
require_relative 'model_base_controller'

# TODO: для каждого паттерна у нас есть консенсус паттерн (некий его прототип) 
# с известной длиной и значением метрики 
# В боте нужно будет для каждой из трёх метрик (после коммитов) сверять временной ряд 
# с прототипом, считать z-евклидово расстояние и если оно ниже порога - БУМ - генерим САРА
class V2Model < ModelBaseController
  def Initialize
    puts 'Initializing model -> v2-ml'
  end

  def train
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def predict
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def start_advisor
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

end

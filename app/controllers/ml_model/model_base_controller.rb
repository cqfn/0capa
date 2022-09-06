# frozen_string_literal: true

class ModelBaseController
  include Concurrent::Async

  def Initialize(model_name)
    puts "Initializing model -> #{model_name}"
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

  protected :Initialize
end

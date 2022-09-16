# frozen_string_literal: true

require 'json'
require_relative 'model_base_controller'

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

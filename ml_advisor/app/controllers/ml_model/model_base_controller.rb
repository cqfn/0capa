# frozen_string_literal: true

class ModelBaseController
  def Initialize(model_name)
    puts "Initializing model -> #{model_name}"
  end

  def train()
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def predict(repo_id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  protected :Initialize
end

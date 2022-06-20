# frozen_string_literal: true

class MetricsBaseController
  @@extractor_seetings

  def Initialize(extractor_name)
    puts "Initializing extractor -> #{extractor_name}"
    @extractor_seetings = TomSetting.find_by(agentname: extractor_name)
  end

  def get_last_update(json)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def runAnalysis()
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def get_settings
    @extractor_seetings
  end

  protected :Initialize
end

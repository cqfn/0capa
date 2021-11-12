# frozen_string_literal: true

class RadarBaseController
  @@radar_seetings

  def Initialize(radar_name)
    puts "Initializing radar -> #{radar_name}"
    @radar_seetings = TomSetting.find_by(agentname: radar_name)
  end

  def get_last_update(json)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def getSourceCode()
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def get_settings
    @radar_seetings
  end

  protected :Initialize
end

# frozen_string_literal: true

#TODO: implement the class methods
require "json"
require_relative "radar_base_controller"

class GitlabRadar < RadarBaseController
  def initialize
    puts "initialize GitlabRadar"
    Initialize("gitlab")
  end

  def get_last_update(json)
    # implementation
  end
end

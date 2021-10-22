# frozen_string_literal: true

#TODO: implement the class methods
require "json"
require_relative "base_radar_controller"

class GitlabRadar < RadarBaseController
  def initialize
    puts "initialize GitlabRadar"
    _Initialize("gitlab")
  end
end

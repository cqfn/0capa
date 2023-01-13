# frozen_string_literal: false

require 'json'
require 'git'
require 'fileutils'
require 'socket'

require_relative 'radar_base_controller'

class GithubRadar < RadarBaseController
  SOURCE = 'github'.freeze
  @@Tokens = nil
  @@call_count = 0
  @@External_threar_stop = false
  @@Is_active_instance = false

  def initialize
    puts 'initialize class GithubRadar'
    Initialize(SOURCE)
  end

  def start_radar
    puts 'initializing radar...'
    @@External_threar_stop = false
    if @@Is_active_instance == false
      puts 'There is no active instance, setting up a new one...'
      @@Is_active_instance = true
      CheckNewInvitationsJob.perform_later
      CheckReposUpdateJob.perform_later
    else
      puts 'There is already an instance runing...'
      false
    end
  end

  def stop_radar
    @@External_threar_stop = true
    puts 'Signal stop sent...'
  end
end

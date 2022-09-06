# frozen_string_literal: true

module Web
  class TomReportController < ApplicationController
    def index
      @status_label = { 'P' => 'Pending', 'D' => 'Downloaded', 'S' => 'Scanned', 'F' => 'Finised', 'E' => 'Error' }
      repo_name = params[:repo_name]
      puts "repo_name -> #{repo_name}"
      @repo_name = params[:repo_name]
      @push_info = TomPushInfo.where(full_name: repo_name)

      render 'reports/index'
    end
  end
end

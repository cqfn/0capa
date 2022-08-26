class ReportController < ApplicationController
  def index
    @status_label = { "P" => "Pending", "D" => "Downloaded", "S" => "Scanned", "F" => "Finished", "E" => "Error" }
    repo_name = params[:repo_name]
    puts "repo_name -> " + repo_name.to_s
    @repo_name = params[:repo_name]
    @push_info = TomPushInfo.where(full_name: repo_name)
  end
end

# frozen_string_literal: true

include ActionController::Cookies

class ReportController < ApplicationController
  def index
    @username = nil
    @logged = false
    @project_list = []
    unless cookies[:github_token].nil?
      @logged = true
      response = HTTP[Authorization: "Bearer #{cookies[:github_token]}"].get('https://api.github.com/user')
      json = JSON.parse(response)
      @username = json['login']
    end

    if @logged && !@username.nil?
      @project_list = TomProject.where('owner_login = :owner_login', {
                                         owner_login: @username
                                       })
    end
    @status_label = { 'P' => 'Pending', 'D' => 'Downloaded', 'S' => 'Scanned', 'F' => 'Finished', 'E' => 'Error' }
    repo_name = params[:repo_name]
    puts "repo_name -> #{repo_name}"
    @repo_name = params[:repo_name]
    @push_info = TomPushInfo.where(full_name: repo_name)
  end
end

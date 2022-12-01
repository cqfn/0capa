# frozen_string_literal: true

include ActionController::Cookies

class ReportController < ApplicationController
  def index
    @username = nil
    @logged = false
    @project_list = []
    @commit_metrics = 0
    @repos_metrics = 0
    @issues_metrics = 0
    @capas_predicted = []

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
      @repos_metrics = @project_list.length
      @commit_metrics = TomCommitsMetric.all.length
      @capas_predicted = TomProjectCapaPredictions.all

    end
  end
end

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
    @capas_predicted = GeneratedCapa.all
    @capas_predicted_count = GeneratedCapa.count

    @patterns = Pattern.all

    unless cookies[:github_token].nil?
      @logged = true
      response = HTTP[Authorization: "Bearer #{cookies[:github_token]}"].get('https://api.github.com/user')
      json = JSON.parse(response)
      @username = json['login']
    end

    return unless @logged && !@username.nil?

    @project_list = TomProject.where('owner_login = :owner_login', {
                                       owner_login: @username
                                     })
    @repos_metrics = @project_list.length
    @commit_metrics = TomCommitsMetric.all.length
    @issues_metrics = Pattern.all.length
  end
end

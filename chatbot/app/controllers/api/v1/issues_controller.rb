require "http"
require "json"

class Api::V1::IssuesController < ApplicationController
  skip_before_action :verify_authenticity_token
  @base_uri = 'https://api.github.com/repos/xavzelada/repo_test/issues'

  def create
    activations = TomRadarActivation.find_by(status: "Pending")
    settings = TomSetting.find_by(agentname: 'github')


    TomRadarActivation.where(status: "Pending").each do | issue |

      puts issue.id
      response = HTTP[:accept => "application/vnd.github.v3+json",:Authorization => "token " + settings.apisecret ].post('https://api.github.com/repos/xavzelada/repo_test/issues', :json => { :title => issue.issuetitle, :body => issue.issuebody })
      # puts JSON.pretty_generate( response)
      if response.code == 201
        issue.status = "Success"
        issue.save
      else
        print('Error creating an ticket') 
        puts JSON.pretty_generate( response.parse)
      end
      # puts response
    end

    render json: {message: "Posting issues finished"}, status: 200

  end
end

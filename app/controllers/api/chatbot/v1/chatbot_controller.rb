class Api::Chatbot::V1::ChatbotController < ApplicationController

  @tokens = nil
  @call_count = 0
  @connection_xargs = TomSetting.find_by(agentname: 'github')
  @basic_url = @connection_xargs.issues_info_url.sub! '#repo_fullname'
  def welcome_issue
    issue_body = 'some-body'

    response = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{getNextToken}"].post(
      @basic_url, json: { title: "Welcome issue over repo", body: issue_body })

    if response.code == 201
      render json: { message: 'Call caught' }, status: 200
    else
      puts 'Error creating an ticket'
      puts JSON.pretty_generate(response.parse)
      render json: { message: 'Something went wrong' }, status: 404
    end
  end

  def initialize
    puts 'initialize Chatbot Daemon'
    get_tokens
  end

  def get_tokens
    if @tokens.nil?
      @tokens = TomTokensQueue.where(source: 'github').where(isactive: 'Y')
    end
  end

  def start_chatbot
    welcome_issue
    while true:
      # тут спамим ишьюсами получается
    end
  end

  def stop_chatbot

    render json: { message: 'Call caught' }, status: 200
  end
end

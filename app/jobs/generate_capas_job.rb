# frozen_string_literal: true

class GenerateCapasJob < ApplicationJob
  queue_as :default
  after_perform do |job|
    self.class.set(wait: 6.hours).perform_later(*job.arguments)
  end

  def perform(*_args)
    TomProject.where(source: 'github').first(5).each do |project|
      capa(project.repo_url, project.mode)
      # do your thing
    end
  end

  def capa(request_url, mode)
    issue_body = ''
    case mode
    when 'Random'
      issue_body = "💫TOM has finished to check you code and it would like to advise you with some actions:
            - #{GeneratedCapa.order('RANDOM()').first.body}"
    when 'ML'
      generated_capa = GeneratedCapa.where(repo_name: request_url, status: 'N').first

      return if generated_capa.nil?

      generated_capa.status = 'S'
      generated_capa.save

      issue_body = "💫TOM has finished to check you code and it would like to advise you with some actions:
            - #{generated_capa.body}"
    end

    capaResponse = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{TomTokensQueue.where(source: 'github').first.token}"].post(
      "#{request_url}/issues", json: { title: '🦥Capa suggestion', body: issue_body }
    )
    puts JSON.pretty_generate(capaResponse.parse)
  end
end

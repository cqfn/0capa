# frozen_string_literal: true

class CheckNewInvitationsJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    self.class.set(wait: 12.minutes).perform_later(*job.arguments)
  end

  def perform(*_args)
    puts 'starting process check_new_invitations...'
    settings = TomSetting.where(agentname: 'github').order(node_name: :asc).first
    response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].get(
      settings.invitations_endpoint, json: {}
    )
    if response.code == 200
      invitations = JSON.parse(response)
      invitations.each do |invitation|
        next unless invitation['expired'] != true

        project = TomProject.new(
          name: invitation['repository']['name'],
          repo_fullname: invitation['repository']['full_name'],
          repoid: invitation['repository']['id'],
          repo_url: invitation['repository']['url'],
          invitation_id: invitation['id'],
          inviter_login: invitation['inviter']['login'],
          permissions: invitation['permissions'],
          is_private: invitation['repository']['private'] == true ? 'True' : 'False',
          owner_login: invitation['repository']['owner']['login'],
          source: 'github',
          isactive: 'Y'
        )
        accept_url = settings.invitations_accept_endpoint.sub! '#invitation_id', invitation['id'].to_s

        invitation_response = HTTP[accept: settings.content_type, Authorization: "token #{settings.apisecret}"].patch(
          accept_url, json: {}
        )
        puts "invitation_response -> #{invitation_response.code}"

        info_url_template = settings.repos_info_url.dup

        puts "info_url_template -> #{info_url_template}"

        request_url = info_url_template.sub! '#repo_fullname', invitation['repository']['full_name']

        puts 'welcomeResponse'
        puts request_url

        issue_body =
          "🥳TOM has started processing your repository. \nSeat & drink some coffee ☕ and wait, in just a couple of minutes the @0capa-demo bot will open the capa suggestion issues for this particular project. You can also visit https://0capa.ru/ 🥸 to read detailed info."

        issue_body.sub! '#capa-1', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-2', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-3', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-4', Capa.order('RANDOM()').first.description
        issue_body.sub! '#capa-5', Capa.order('RANDOM()').first.description

        welcomeResponse = HTTP[accept: 'application/vnd.github.v3+json', Authorization: "token #{TomTokensQueue.where(source: 'github').first.token}"].post(
          "#{request_url}/issues", json: { title: '💥Welcome issue over repo💥', body: issue_body }
        )
        puts JSON.pretty_generate(welcomeResponse.parse)
        if invitation_response.code == 204
          info_url_template = settings.repos_info_url.dup
          puts "info_url_template -> #{info_url_template}"
          if invitation_response.code == 200
            repo = JSON.parse(response)
            project.repo_created_at = DateTime.parse(repo['created_at'])
          else
            puts JSON.pretty_generate(response.parse)
          end
          project.save
        else
          puts 'there was an error accepting the invitation...'
          return false
        end
      end
    else
      puts JSON.pretty_generate(response.parse)
      return false
    end
    true
  rescue StandardError => e
    puts e
    false
  end
end

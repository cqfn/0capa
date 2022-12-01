class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  # Handle issue comment event
  def github_issue_comment(payload)
    puts payload
    if payload.comment.match(/switch/)
      if payload.comment.match(/Random/)
        puts 'скорее всего нас попросили свитчнуться в рандом мод'

      elsif payload.comment.match(/ML/)
        puts 'скорее всего нас попросили свитчнуться в мл мод'

      end
    end

    private

    def webhook_secret(payload)
      'GITHUB_WEBHOOK_SECRET'
    end
  end
end

task import_issues: [:environment] do
  page = 1
  client = Octokit::Client.new(
    :client_id     => ENV['GITHUB_CLIENT_ID'],
    :client_secret => ENV['GITHUB_CLIENT_SECRET']
  )

  loop do
    issues = client.issues('facebook/react-native', per_page: 100, page: page, state: 'all')
    break if issues.blank?

    issues.each do |issue|
      i = Issue.where(number: issue['number']).first_or_create

      i.update_attributes(
        github_id: issue['id'],
        url: issue['url'],
        title: issue['title'],
        body: issue['body'],
        created_at: issue['created_at'],
        updated_at: issue['updated_at'],
        closed_at: issue['closed_at'],
        pull_request: issue['pull_request'].present?
      )

      unless i.closed?
        response = HTTParty.get(issue.comments_url +
                                "?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}")
        comments = JSON.parse(response.body)
        commenters = comments.map { |response|
          response['user']['login']
        }
        i.update_attributes(unique_commenters: commenters.uniq.count)
      end
    end

    page = page + 1
  end
end

  # {
  #   "url": "https://api.github.com/repos/facebook/react-native/issues/comments/105121737",
  #   "html_url": "https://github.com/facebook/react-native/issues/1397#issuecomment-105121737",
  #   "issue_url": "https://api.github.com/repos/facebook/react-native/issues/1397",
  #   "id": 105121737,
  #   "user": {
  #     "login": "iostalk",
  #     "id": 659130,
  #     "avatar_url": "https://avatars.githubusercontent.com/u/659130?v=3",
  #     "gravatar_id": "",
  #     "url": "https://api.github.com/users/iostalk",
  #     "html_url": "https://github.com/iostalk",
  #     "followers_url": "https://api.github.com/users/iostalk/followers",
  #     "following_url": "https://api.github.com/users/iostalk/following{/other_user}",
  #     "gists_url": "https://api.github.com/users/iostalk/gists{/gist_id}",
  #     "starred_url": "https://api.github.com/users/iostalk/starred{/owner}{/repo}",
  #     "subscriptions_url": "https://api.github.com/users/iostalk/subscriptions",
  #     "organizations_url": "https://api.github.com/users/iostalk/orgs",
  #     "repos_url": "https://api.github.com/users/iostalk/repos",
  #     "events_url": "https://api.github.com/users/iostalk/events{/privacy}",
  #     "received_events_url": "https://api.github.com/users/iostalk/received_events",
  #     "type": "User",
  #     "site_admin": false
  #   },
  #   "created_at": "2015-05-25T04:26:20Z",
  #   "updated_at": "2015-05-25T04:26:20Z",
  #   "body": "I wonder know too."
  # },

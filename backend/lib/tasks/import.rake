task import_issues: [:environment] do
  page = 1

  loop do
    issues = Octokit.issues('facebook/react-native', per_page: 100, page: page, state: 'all')
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
    end

    page = page + 1
  end
end

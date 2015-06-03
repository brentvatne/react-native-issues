class IssuesController < ApplicationController
  def open
    render json: Issue.open.all
  end

  def unique_commenters
    render json: Issue.open.all.sort_by { |i| i.unique_commenters || 0 }.reverse
  end

  def tag_counts
    render json: Issue.open_issue_tags
  end
end

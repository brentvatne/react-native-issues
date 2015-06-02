class IssuesController < ApplicationController
  def open
    render json: Issue.open.all
  end

  def tag_counts
    render json: Issue.open_issue_tags
  end
end

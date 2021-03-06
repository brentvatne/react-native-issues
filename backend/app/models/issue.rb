require Rails.root.to_s + '/lib/count_by'

class Issue < ActiveRecord::Base
  validates :github_id, uniqueness: true

  scope :first_triage, -> {
    friday = Date.parse('Friday, May 28, 2015').beginning_of_day
    sunday = Date.parse('Sunday, May 31, 2015').end_of_day

    where('(created_at > ? or updated_at > ? or closed_at > ?) and
           (created_at < ? and updated_at < ? and (closed_at < ? or closed_at is null))',
           friday, friday, friday,
           sunday, sunday, sunday)
  }

  def self.open_issue_tags
    Issue.open.excluding_prs.pluck(:title).
      map { |i| i.match(/\[.*?\]/) }.
      map(&:to_s).
      map { |tag| tag.gsub('[','').gsub(']','') }.
      count_by(&:to_s).
      to_h
  end

  scope :prs, -> {
    where(pull_request: true)
  }

  scope :excluding_prs, -> {
    where(pull_request: false)
  }

  scope :closed, -> {
    where('closed_at is not null')
  }

  scope :open, -> {
    where(closed_at: nil)
  }

  def closed?
    closed_at.present?
  end

  def self.closed_in_first_triage
    Issue.first_triage.sort_by(&:title).map { |i|
      "#{i['closed_at'].present? ? '[Closed]' : '[Open]'}: #{i['title']}"
    }
  end
end

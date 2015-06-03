Rails.application.routes.draw do
  root 'issues#open'
  get '/tag-counts' => 'issues#tag_counts'
  get '/unique-commenters' => 'issues#unique_commenters'
end

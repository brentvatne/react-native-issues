Rails.application.routes.draw do
  root 'issues#open'
  get '/tag-counts' => 'issues#tag_counts'
end

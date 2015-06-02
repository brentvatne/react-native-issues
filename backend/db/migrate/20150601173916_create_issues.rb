class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :github_id
      t.string :url
      t.integer :number
      t.string :title
      t.text :body
      t.boolean :pull_request, default: false, null: false
      t.datetime :closed_at
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

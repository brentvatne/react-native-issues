class AddUniqueIndexToGithubId < ActiveRecord::Migration
  def change
    add_index :issues, :github_id, unique: true
  end
end
